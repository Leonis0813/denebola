# coding: utf-8
require_relative 'config/settings'
require_relative 'lib/http_client'
Dir['models/*'].each {|f| require_relative f }

from = ARGV[0] ? Date.parse(ARGV[0]) : (Date.today - 7)
to = ARGV[1] ? Date.parse(ARGV[1]) : Date.today
client = HTTPClient.new

(from..to).each do |date|
  response = client.get("#{Settings.url}#{Settings.path['race_list']}/#{date.strftime('%Y%m%d')}")
  race_ids = response.body.scan(%r[.*/race/(\d+)]).flatten

  race_ids.each do |race_id|
    response = client.get("#{Settings.url}#{Settings.path['race']}/#{race_id}")
    Race.new(response.body).save!
  end
end
