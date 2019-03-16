# coding: utf-8
require 'logger'
require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/*'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

logger = Logger.new('log/extract.log')
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

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
  next unless File.exists?(file_path)
  race_ids = File.read(file_path).split("\n")
  logger.info(:action => 'read', :file_path => File.basename(file_path), :ids => race_ids)

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    next unless File.exists?(file_path)
    html = File.read(file_path)
    logger.info(:action => 'read', :resource => 'race', :file_path => File.basename(file_path))

    parsed_html = Nokogiri::HTML.parse(html)
    race_attribute = extract_race(parsed_html)
    next unless race_attribute

    race = Race.find_or_create_by!(race_attribute)
    logger.info(:action => 'create', :resource => 'race', :race_id => race.id)

    _, *rows = parsed_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      extry_attribute = extract_entry(row)
      entry = race.entries.find_or_create_by!(entry_attribute.except(:horse_id))
      logger.info(:action => 'create', :resource => 'entry', :entry_id => entry.id)

      horse_id = entry_attribute[:horse_id]
      unless Horse.exists?(:horse_id => horse_id)
        file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
        html = File.read(file_path) unless File.exists?(file_path)
        logger.info(:action => 'read', :resource => 'horse', :file_path => File.basename(file_path))

        parsed_html = Nokogiri::HTML.parse(html)
        horse_attribute = extract_horse(parsed_html)
        if horse_attribute
          Horse.create!(horse_attribute.merge(:horse_id => entry[:horse_id]))
          logger.info(:action => 'create', :resource => 'horse', :horse_id => horse_id)
      end
    end
  end
end
