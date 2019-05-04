require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['models/*'].each {|f| require_relative f }

logger = DenebolaLogger.new(Settings.logger.path.aggregate)
logger.info('Start Aggregation')

new_features = Entry.pluck(:race_id, :id).uniq - Feature.pluck(:race_id, :entry_id).uniq

logger.info("# of Updated Features = #{new_features.size}")

new_features.each do |race_id, entry_id|
  attribute = {race_id: race_id, entry_id: entry_id}

  race = Race.find(race_id)
  attribute.merge!(race.attributes.slice(*Feature.attribute_names)).symbolize_keys!

  entry = Entry.find(entry_id)
  attribute.merge!(entry.attributes.slice(*Feature.attribute_names)).symbolize_keys!

  horse = Horse.find(entry.horse_id)
  attribute.merge!(horse.attributes.slice(*Feature.attribute_names)).symbolize_keys!

  weight_per = if entry.burden_weight.to_i.positive? and entry.weight.to_i.positive?
                 entry.burden_weight / entry.weight
               end
  attribute.merge!(month: race.start_time.month, weight_per: weight_per)

  feature = Feature.create!(attribute.except(:id))

  logger.info(action: 'create', resource: 'feature', feature_id: feature.id)
end

logger.info('Finish Aggregation')
