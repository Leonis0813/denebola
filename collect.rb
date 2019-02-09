# coding: utf-8
require 'logger'
require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/http_client'
Dir['models/*'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

logger = Logger.new('log/collect.log')
logger.formatter = proc do |severity, datetime, progname, message|
  time = datetime.utc.strftime(Settings.logger.time_format)
  log = "[#{severity}] [#{time}]: #{message}"
  puts log if ENV['STDOUT'] == 'on'
  "#{log}\n"
end

def extract_race_info(html)
  {}.tap do |feature|
    race_data = html.xpath('//dl[contains(@class, "racedata")]')

    track, weather, _, start_time, _ = race_data.search('span').text.split('/')
    feature[:track] = track[0].sub('ダ', 'ダート')
    feature[:direction] = track[1]
    feature[:distance] = track.match(/(\d*)m/)[1].to_i
    feature[:weather] = weather.match(/天候 : (.*)/)[1]
    feature[:grade] = race_data.search('h1').text.match(/\((.*)\)$/).try(:[], 1)
    feature[:place] = html.xpath('//ul[contains(@class, "race_place")]').first
                      .children[1].text.match(/<a.*class="active">(.*?)<\/a>/)[1]
    feature[:round] = race_data.search('dt').text.strip.match(/^(\d*) R$/)[1].to_i

    race_date = html.xpath('//li[@class="result_link"]').text.match(/(\d*年\d*月\d*日)のレース結果/)[1]
    race_date = race_date.gsub(/年|月/, '-').sub('日', '')
    start_time = start_time.match(/発走 : (.*)/)[1]
    feature[:start_time] = "#{race_date} #{start_time}:00"

    _, *data = race_data.xpath('//table[contains(@class, "race_table")]').search('tr')
    feature[:entries] = data.map do |entry|
      attributes = entry.search('td').map(&:text).map(&:strip)

      {
        :age => attributes[4].match(/(\d+)\z/)[1].to_i,
        :burden_weight => attributes[5].to_f,
        :number => attributes[2].to_i,
        :weight => attributes[14].match(/\A(\d+)/).try(:[], 1).to_f,
        :weight_diff => attributes[14].match(/\((.+)\)$/).try(:[], 1).to_f,
        :jockey => attributes[6],
        :result => {:order => attributes[0]},
      }
    end
  end
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

    parsed_html = Nokogiri::HTML.parse(html.gsub('&nbsp;', ' '))
    race_info = extract_race_info(parsed_html)
    next unless race_info

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
