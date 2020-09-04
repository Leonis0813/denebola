require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

class Aggregator
  OPERATION_CREATE = 'create'.freeze
  OPERATION_UPDATE = 'update'.freeze
  VALID_OPERATIONS = [OPERATION_CRATE, OPERATION_UPDATE].freeze

  include ArgumentUtil

  class << self
    def work!
      logger = DenebolaLogger.new(Settings.logger.path.aggregate)
      ArgumentUtil.logger = logger
      ApplicationRecord.operation = operation

      aggregator = new(logger)

      logger.info('Start Aggregation')

      case operation
      when OPERATION_CREATE
        aggregator.create_features(from, to)
      when OPERATION_UPDATE
        aggregator.update_features(from, to)
      end

      logger.info('Finish Aggregation')
    end

    def from
      case operation
      when OPERATION_CREATE
        super.blank? ? Date.today - 30 : super
      when OPERATION_UPDATE
        if super.nil?
          logger.error('from parameter not specified')
          raise StandardError
        elsif not super.match?(/\A[1-9][0-9]*\z/)
          logger.error("invalid from specified: #{super}")
          raise StandardError
        else
          super.to_i
        end
      end
    end

    def to
      case operation
      when OPERATION_CREATE
        super.blank? ? Date.today : super
      when OPERATION_UPDATE
        if super.nil?
          logger.error('to parameter not specified')
          raise StandardError
        elsif not super.match?(/\A[1-9][0-9]*\z/)
          logger.error("invalid to specified: #{from}")
          raise StandardError
        else
          super.to_i
        end
      end
    end

    def operation
      operation = super.blank? ? OPERATION_CREATE : super

      unless VALID_OPERATION.include?(operation)
        logger.error("invalid operation specified: #{operation}")
        raise StandardError
      end

      operation
    end
  end

  def initialize(logger)
    @logger = logger
  end

  def create_features(from, to)
    horse_race_ids = Entry.where(order: (1..18).to_a.map(&:to_s))
                          .where.not(weight: nil)
                          .where('DATE(updated_at) >= ?', from)
                          .where('DATE(updated_at) <= ?', to)
                          .pluck(:horse_id, :race_id)

    horse_race_ids.reject! do |horse_id, race_id|
      horse = Horse.find(horse_id)
      race = Race.find(race_id)
      Feature.exists?(horse_id: horse.horse_id, race_id: race.race_id)
    end

    @logger.info("# of Target Features = #{horse_race_ids.size}")

    horse_race_ids.find_each(batch_size: 100) do |horse_id, race_id|
      entry = Entry.find_by(horse_id: horse_id, race_id: race_id)
      attribute = feature_attribute(entry)
      next if attribute.nil?

      begin
        feature = Feature.create!(attribute)
        @logger.info(base_log_attribute.merge(feature_id: feature.id))
      rescue ActiveRecord::RecordInvalid => e
        @logger.error(base_log_attribute.merge(errors: e.record.errors))
        raise
      end
    end
  end

  def update_features(from, to)
    features = Feature.where('id >= ?', from).where('id <= ?', to)

    @logger.info("# of Target Features = #{features.size}")

    features.find_each(batch_size: 100) do |feature|
      race = Race.find_by(race_id: feature.race_id)
      horse = Horse.find_by(horse_id: feature.horse_id)
      entry = Entry.find_by(horse_id: horse.id, race_id: race.id)

      attribute = feature_attribute(entry)
      next if attribute.nil?

      begin
        feature.update!(attribute)
        @logger.info(base_log_attribute.merge(feature_id: feature.id))
      rescue ActiveRecord::RecordInvalid => e
        @logger.error(base_log_attribute.merge(errors: e.record.errors))
        raise
      end
    end
  end

  private

  def base_log_attribute
    @base_log_attribute ||= {action: Feature.operation, resource: 'feature'}
  end

  def feature_attribute(entry)
    return if entry.race.nil? or entry.horse.nil? or entry.jockey.nil?

    attribute = {race_id: entry.race.race_id, horse_id: entry.horse.horse_id}
    feature_attribute_names = Feature.attribute_names - %w[horse_id race_id]

    attribute.merge!(entry.race.attributes.slice(*feature_attribute_names))
    attribute.merge!(entry.horse.attributes.slice(*feature_attribute_names))
    attribute.merge!(entry.attributes.slice(*feature_attribute_names))
    attribute.merge(extra_attribute(entry)).symbolize_keys
  end

  def extra_attribute(entry)
    race = entry.race
    horse = entry.horse
    jockey = entry.jockey

    entry_time = race.start_time
    results_before = horse.results_before(entry_time)

    blank = if results_before.second
              (entry_time.to_date - results_before.first.race.start_time.to_date).to_i
            else
              0
            end

    sum_distance = results_before.map {|result| result.race.distance }.inject(:+)
    distance_diff = if sum_distance
                      average_distance = sum_distance / horse.entry_times(entry_time)
                      (race.distance - average_distance).abs / average_distance.to_f
                    else
                      0
                    end

    {
      blank: blank,
      distance_diff: distance_diff,
      entry_times: horse.entry_times(entry_time),
      horse_average_prize_money: horse.average_prize_money(entry_time),
      jockey_average_prize_money: jockey.average_prize_money(entry_time),
      jockey_win_rate: jockey.win_rate(entry_time),
      jockey_win_rate_last_four_races: jockey.win_rate_last_four_races(entry_time),
      last_race_order: horse.last_race_order(entry_time),
      month: race.month,
      rate_within_third: horse.rate_within_third(entry_time),
      second_last_race_order: horse.second_last_race_order(entry_time),
      weight_per: entry.weight_per,
      win_times: horse.win_times(entry_time),
      won: entry.won,
    }
  end
end

Aggregator.work!
