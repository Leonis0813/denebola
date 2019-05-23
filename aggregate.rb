require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['models/*'].each {|f| require_relative f }

logger = DenebolaLogger.new(Settings.logger.path.aggregate)

def extra_attribute(race, entry, horse)
  entry_time = race.start_time
  results_before = horse.results_before(entry_time)

  blank = if results_before.second
            (entry_time.to_date - results_before.second.race.start_time.to_date).to_i
          else
            0
          end

  sum_distance = results_before.map {|result| result.race.distance }.inject(:+)
  average_distance = sum_distance / horse.entry_times(entry_time).to_f
  distance_diff = (race.distance - average_distance).abs / average_distance

  {
    average_prize_money: horse.average_prize_money(entry_time),
    blank: blank,
    distance_diff: distance_diff,
    entry_times: horse.entry_times(entry_time),
    last_race_order: horse.last_race_order(entry_time),
    month: race.month,
    rate_within_third: horse.rate_within_third(entry_time),
    second_last_race_order: horse.second_last_race_order(entry_time),
    weight_per: entry.weight_per,
    win_times: horse.win_times(entry_time),
    won: entry.won,
  }
end

logger.info('Start Aggregation')

entries = Entry.joins(:race).joins(:horse).where(:order => (1 .. 18).to_a.map(&:to_s))
          .pluck('races.race_id', 'horses.horse_id').uniq
features = Feature.pluck(:race_id, :horse_id).uniq
new_features = entries - features

logger.info("# of Updated Features = #{new_features.size}")

new_features.each do |race_id, horse_id|
  attribute = {race_id: race_id, horse_id: horse_id}
  feature_attributes = Feature.attribute_names - %w[horse_id race_id]

  race = Race.find_by(race_id: race_id)
  next unless race

  attribute.merge!(race.attributes.slice(*feature_attributes)).symbolize_keys!

  horse = Horse.find_by(horse_id: horse_id)
  next unless horse

  attribute.merge!(horse.attributes.slice(*feature_attributes)).symbolize_keys!

  entry = Entry.find_by(race_id: race.id, horse_id: horse.id)
  next unless entry

  attribute.merge!(entry.attributes.slice(*feature_attributes)).symbolize_keys!

  attribute.merge!(extra_attribute(race, entry, horse))

  feature = Feature.create!(attribute.except(:id, :order))

  logger.info(action: 'create', resource: 'feature', feature_id: feature.id)
end

logger.info('Finish Aggregation')
