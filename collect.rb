require 'logger'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/http_client'
require_relative 'lib/html'
Dir['models/*'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

from = ARGV[0] ? Date.parse(ARGV[0]) : (Date.today - 7)
to = ARGV[1] ? Date.parse(ARGV[1]) : Date.today
client = HTTPClient.new
logger = Logger.new('log/collect.log')

Settings.backup_dir.to_h.values.each {|path| FileUtils.mkdir_p(File.join(BACKUP_DIR, path)) }

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
  race_ids = if File.exists?(file_path)
               ids = File.read(file_path).split("\n")
               logger.info(:action => 'fetch', :resource => 'race_list', :file_path => File.basename(file_path))
               ids
             else
               res = client.get("#{Settings.url}#{Settings.path.race_list}/#{date}")
               logger.info(:action => 'fetch', :resource => 'race_list', :uri => res.uri.to_s, :status => res.code)
               ids = res.body.scan(%r[.*/race/(\d+)]).flatten
               File.open(file_path, 'w') {|out| out.write(ids.join("\n")) }
               ids
             end

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    html = if File.exists?(file_path)
             html = File.read(file_path)
             logger.info(:action => 'fetch', :resource => 'race', :file_path => File.basename(file_path))
             html
           else
             res = client.get("#{Settings.url}#{Settings.path.race}/#{race_id}")
             logger.info(:action => 'fetch', :resource => 'race', :uri => res.uri.to_s, :status => res.code)
             body = res.body.encode("utf-8", "euc-jp", :undef => :replace, :replace => '?')
             File.open(file_path, 'w') {|out| out.write(body) }
             body
           end

    race_info = HTML.parse(html)
    race = Race.find_or_create_by!(race_info.except(:entries))
    race_info[:entries].each do |entry|
      e = race.entries.find_or_create_by!(entry.except(:result))
      e.result = Result.find_or_create_by!(entry[:result].merge(:race_id => race.id))
    end
  end
end
