# coding: utf-8
require_relative 'config/settings'
require_relative 'lib/http_client'
Dir['models/*'].each {|f| require_relative f }

from = ARGV[0] ? Date.parse(ARGV[0]) : (Date.today - 7)
to = ARGV[1] ? Date.parse(ARGV[1]) : Date.today
client = HTTPClient.new

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join('backup/race_list', "#{date}.txt")
  race_ids = if File.exists?(file_path)
               File.read(file_path).split("\n")
             else
               response = client.get("#{Settings.url}#{Settings.path['race_list']}/#{date}")
               ids = response.body.scan(%r[.*/race/(\d+)]).flatten
               FileUtils.mkdir_p('backup/race_list')
               File.open(file_path, 'w') {|out| out.write(ids.join("\n")) }
               ids
             end

  race_ids.each do |race_id|
    file_path = File.join('backup/race', "#{race_id}.html")
    html = if File.exists?(file_path)
             File.read(file_path)
           else
             response = client.get("#{Settings.url}#{Settings.path['race']}/#{race_id}")
             body = response.body.encode("utf-8", "euc-jp", :undef => :replace, :replace => '?')
             FileUtils.mkdir_p('backup/race')
             File.open(file_path, 'w') {|out| out.write(body) }
             body
           end

    Race.new(html).save!
  end
end
