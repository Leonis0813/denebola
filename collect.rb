require 'logger'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/http_client'
require_relative 'lib/html'
Dir['models/*'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

logger = Logger.new('log/collect.log')
logger.formatter = proc do |severity, datetime, progname, message|
  time = datetime.utc.strftime(Settings.logger.time_format)
  log = "[#{severity}] [#{time}]: #{message}"
  puts log if ENV['STDOUT'] == 'on'
  "#{log}\n"
end

begin
  from = ARGV.find {|arg| arg.start_with?('--from=') }
  from = from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : (Date.today - 7)
  to = ARGV.find {|arg| arg.start_with?('--to=') }
  to = to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : Date.today
rescue Exception => e
  logger.error(e.backtrace.join("\n"))
  raise e
end

client = HTTPClient.new

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
    logger.info(:action => 'create', :resource => 'race', :id => race.id)
    race_info[:entries].each do |entry|
      e = race.entries.find_or_create_by!(entry.except(:result))
      logger.info(:action => 'create', :resource => 'entry', :id => e.id)
      e.result = Result.find_or_create_by!(entry[:result].merge(:race_id => race.id))
      logger.info(:action => 'create', :resource => 'result', :id => e.result.id)
    end
  end
end
