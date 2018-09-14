require 'logger'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/*'].each {|f| require_relative f }

logger = Logger.new('log/aggregate.log')
logger.formatter = proc do |severity, datetime, progname, message|
  time = datetime.utc.strftime(Settings.logger.time_format)
  log = "[#{severity}] [#{time}]: #{message}"
  puts log if ENV['STDOUT'] == 'on'
  "#{log}\n"
end

logger.info('Start Aggregation')

new_features = Result.pluck(:race_id, :entry_id).uniq - Feature.pluck(:race_id, :entry_id).uniq

logger.info("# of Updated Features = #{new_features.size}")

new_features.each do |race_id, entry_id|
  feature = Feature.new(:race_id => race_id, :entry_id => entry_id)

  race = Race.find(feature.race_id)
  feature_attributes = race.attributes.slice(*Feature.attribute_names)

  entry = Entry.find(feature.entry_id)
  feature_attributes.merge!(entry.attributes.slice(*Feature.attribute_names))

  result = Result.find_by(:race_id => feature.race_id, :entry_id => feature.entry_id)
  feature_attributes.merge!(result.attributes.slice(*Feature.attribute_names))
  feature.save!(feature_attributes.except('id', 'created_at', 'updated_at'))

  logger.info(feature_attributes.except('race_id', 'entry_id', 'created_at', 'updated_at'))
end

logger.info('Finish Aggregation')
