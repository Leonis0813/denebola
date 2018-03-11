require 'logger'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/*'].each {|f| require_relative f }

diffs = Result.pluck(:race_id, :entry_id).uniq - Feature.pluck(:race_id, :entry_id).uniq
updated_features = diffs.map do |race_id, entry_id|
  Feature.new(:race_id => race_id, :entry_id => entry_id)
end

updated_features.each do |feature|
  race = Race.find(feature.race_id)
  feature_attributes = race.attributes.slice(*Feature.attribute_names)

  entry = Entry.find(feature.entry_id)
  feature_attributes.merge!(entry.attributes.slice(*Feature.attribute_names))

  result = Result.find_by(:race_id => feature.race_id, :entry_id => feature.entry_id)
  feature_attributes.merge!(result.attributes.slice(*Feature.attribute_names))
  feature.update!(feature_attributes.except('id', 'created_at', 'updated_at'))
end
