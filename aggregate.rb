require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['models/*'].each {|f| require_relative f }

logger = DenebolaLogger.new(Settings.logger.path.aggregate)
logger.info('Start Aggregation')

entries = Entry.joins(:race).joins(:horse).pluck('races.race_id', 'horses.horse_id').uniq
features = Feature.pluck(:race_id, :horse_id).uniq
new_features = entries - features

logger.info("# of Updated Features = #{new_features.size}")

new_features.each do |race_id, horse_id|
  attribute = {race_id: race_id, horse_id: horse_id}
  feature_attributes = Feature.attribute_names - %w[horse_id race_id]

  race = Race.find_by(race_id: race_id)
  attribute.merge!(race.attributes.slice(*feature_attributes)).symbolize_keys!
  next unless race

  horse = Horse.find_by(horse_id: horse_id)
  attribute.merge!(horse.attributes.slice(*feature_attributes)).symbolize_keys!
  next unless horse

  entry = Entry.find_by(race_id: race.id, horse_id: horse.id)
  attribute.merge!(entry.attributes.slice(*feature_attributes)).symbolize_keys!
  next unless entry

  results = horse.results
  entry_times = results.size
  average_prize_money = results.map(&:prize_money).inject(:+) / entry_times.to_f

  blank = race.start_time - horse.results.second.race.start_time if horse.results.second

  sum_distance = horse.results.map {|result| result.race.distance }.inject(:+)
  average_distance = sum_distance / entry_times.to_f
  distance_diff = (race.distance - average_distance).abs / average_distance

  within_third_times = results.first(3).select {|result| result.order.to_i <= 3 }.size
  rate_within_third = within_third_times / 3.0

  weight_per = if entry.burden_weight.to_i.positive? and entry.weight.to_i.positive?
                 entry.burden_weight / entry.weight
               end

  win_times = results.select {|result| result.order.to_i == 1 }.size

  attribute.merge!(
    average_prize_money: average_prize_money,
    blank: blank,
    distance_diff: distance_diff,
    entry_times: entry_times,
    last_race_final_600m_time: results.second&.final_600m_time,
    last_race_order: results.second&.order&.to_i,
    month: race.start_time.month,
    rate_within_third: rate_within_third,
    second_last_race_order: results.third&.order&.to_i,
    weight_per: weight_per,
    win_times: win_times,
    won: entry.order == '1',
  )

  feature = Feature.create!(attribute.except(:id, :order))

  logger.info(action: 'create', resource: 'feature', feature_id: feature.id)
end

logger.info('Finish Aggregation')
