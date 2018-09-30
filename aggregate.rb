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
  attribute = {:race_id => race_id, :entry_id => entry_id}

  race = Race.find(race_id)
  attribute.merge!(race.attributes.slice(*Feature.attribute_names))

  entry = Entry.find(entry_id)
  attribute.merge!(entry.attributes.slice(*Feature.attribute_names))

  result = Result.find_by(:race_id => race_id, :entry_id => entry_id)
  attribute.merge!(result.attributes.slice(*Feature.attribute_names))

  Feature.create!(attribute)

  logger.info(attribute)
end

logger.info('Finish Aggregation')
