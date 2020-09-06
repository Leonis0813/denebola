require 'active_support'
require 'active_support/core_ext/object/blank'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

class Aggregator
  OPERATION_CREATE = 'create'.freeze
  OPERATION_UPDATE = 'update'.freeze
  VALID_OPERATIONS = [OPERATION_CREATE, OPERATION_UPDATE].freeze

  include ArgumentUtil

  class << self
    def work!
      logger = DenebolaLogger.new(Settings.logger.path.aggregate)
      ArgumentUtil.logger = logger
      ApplicationRecord.operation = operation

      aggregator = new(logger)

      logger.info('Start Aggregation')

      begin
        case operation
        when OPERATION_CREATE
          aggregator.create_features(from, to)
        when OPERATION_UPDATE
          raise StandardError, 'too many features updated' if (to - from) > 200000

          aggregator.update_features(from, to)
        end
      rescue ActiveRecord::RecordInvalid => e
        logger.error(aggregator.base_log_attribute.merge(errors: e.record.errors))
        raise
      end

      logger.info('Finish Aggregation')
    rescue StandardError => e
      logger.error(e.backtrace.join("\n"))
      raise
    end

    def from
      case operation
      when OPERATION_CREATE
        super.blank? ? Date.today - 30 : Date.parse(super)
      when OPERATION_UPDATE
        raise StandardError, 'from parameter not specified' if super.nil?
        unless super.match?(/\A[1-9][0-9]*\z/)
          raise StandardError, "invalid from specified: #{super}"
        end

        super.to_i
      end
    end

    def to
      case operation
      when OPERATION_CREATE
        super.blank? ? Date.today : Date.parse(super)
      when OPERATION_UPDATE
        raise StandardError, 'to parameter not specified' if super.nil?
        unless super.match?(/\A[1-9][0-9]*\z/)
          raise StandardError, "invalid to specified: #{from}"
        end

        super.to_i
      end
    end

    def operation
      operation = super.blank? ? OPERATION_CREATE : super

      unless VALID_OPERATIONS.include?(operation)
        raise StandardError, "invalid operation specified: #{operation}"
      end

      operation
    end
  end

  def initialize(logger)
    @logger = logger
  end

  def create_features(from, to)
    (from..to).each do |date|
      entries = Entry.joins(:race)
                     .where(order: (1..18).to_a.map(&:to_s))
                     .where.not(weight: nil)
                     .where('DATE(races.start_time) = ?', date)

      @logger.info(base_log_attribute.merge(date: date, entries: entries.size))

      race = horse = jockey = attribute = feature = nil
      entries.find_each do |entry|
        race = entry.race
        horse = entry.horse
        jockey = entry.jockey
        next if race.nil? or horse.nil? or jockey.nil?
        next if Feature.exists?(horse_id: horse.horse_id, race_id: race.race_id)

        attribute = feature_attribute(entry, race, horse, jockey)
        next if attribute.nil?

        feature = Feature.create!(attribute)
        @logger.info(base_log_attribute.merge(feature_id: feature.id))
      end
    end
  end

  def update_features(from, to)
    features = Feature.where('id >= ?', from).where('id <= ?', to)

    @logger.info("# of Target Features = #{features.size}")

    race = horse = entry = jockey = attribute = nil
    features.find_each(batch_size: 100) do |feature|
      race = Race.find_by(race_id: feature.race_id)
      horse = Horse.find_by(horse_id: feature.horse_id)
      next if race.nil? or horse.nil?

      entry = Entry.find_by(horse_id: horse.id, race_id: race.id)
      jockey = entry.jockey
      next if jockey.nil?

      attribute = feature_attribute(entry, race, horse, jockey)
      next if attribute.nil?

      feature.assign_attributes(attribute.except(:id, :horse_id, :race_id))
      feature_info = {feature_id: feature.id, changes: feature.changes}
      feature.save!
      @logger.info(base_log_attribute.merge(feature_info))
    end
  end

  def base_log_attribute
    @base_log_attribute ||= {action: Feature.operation, resource: 'feature'}
  end

  private

  def feature_attribute(entry, race, horse, jockey)
    attribute = {race_id: race.race_id, horse_id: horse.horse_id}
    feature_attribute_names = Feature.attribute_names - %w[horse_id race_id]

    attribute.merge!(race.attributes.slice(*feature_attribute_names))
    attribute.merge!(horse.attributes.slice(*feature_attribute_names))
    attribute.merge!(entry.attributes.slice(*feature_attribute_names))
    attribute.merge(extra_attribute(entry, race, horse, jockey)).symbolize_keys
  end

  def extra_attribute(entry, race, horse, jockey)
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
