require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

class Aggregator
  include ArgumentUtil

  def self.work!
    logger = DenebolaLogger.new(Settings.logger.path.aggregate)
    ArgumentUtil.logger = logger

    check_operation(operation)
    ApplicationRecord.operation = operation

    aggregator = new(logger)

    logger.info('Start Aggregation')

    entries = Entry.where(order: (1..18).to_a.map(&:to_s))
                   .where.not(weight: nil)
                   .where('DATE(entries.updated_at) >= ?', from.strftime('%F'))
                   .where('DATE(entries.updated_at) <= ?', to.strftime('%F'))

    entries.find_each(batch_size: 100) {|entry| aggregator.create_feature(entry) }

    logger.info('Finish Aggregation')
  end

  def initialize(logger)
    @logger = logger
  end

  def create_feature(entry)
    attribute = create_feature_attribute(entry)
    return if attribute.nil?

    begin
      feature = Feature.create_or_update!(attribute)
      @logger.info(base_log_attribute.merge(feature_id: feature.id))
    rescue ActiveRecord::RecordInvalid => e
      @logger.error(base_log_attribute.merge(errors: e.record.errors))
      raise
    end
  end

  private

  def base_log_attribute
    @base_log_attribute ||= {action: Feature.operation, resource: 'feature'}
  end

  def create_feature_attribute(entry)
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
