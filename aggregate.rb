# coding: utf-8
require 'fileutils'
require 'mysql2'
require_relative 'config/settings'
require_relative 'lib/mysql_client'
Dir['models/*'].each {|f| require_relative f }

client = MysqlClient.new
results = client.select([:race_id, :entry_id], :results)
latest_id_pairs = results.map {|r| [r['race_id'], r['entry_id']] }

results = client.select([:race_id, :entry_id], :features)
old_id_pairs = results.map {|r| [r['race_id'], r['entry_id']] }

updated_features = (latest_id_pairs - old_id_pairs).map do |id_pair|
  feature = Feature.new(:race_id => id_pair.first, :entry_id => id_pair.last)
  feature.save!
  feature
end

updated_features.each do |feature|
  race_attributes = Race.find(feature.race_id).first
  race_attributes.delete('id')
  race_attributes.delete('start_time')
  feature.update!(race_attributes)

  entry_attributes = Entry.find(feature.entry_id).first
  entry_attributes.delete('id')
  feature.update!(entry_attributes)

  result_attributes = Result.find_by(:race_id => feature.race_id, :entry_id => feature.entry_id)
  result_attributes.delete('id')
  feature.update!(result_attributes)
end
