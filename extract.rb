require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['extract/*'].each {|f| require_relative f }
Dir['models/*'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
logger = DenebolaLogger.new(Settings.logger.path.extract)

begin
  from = ARGV.find {|arg| arg.start_with?('--from=') }
  from = from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : (Date.today - 30)
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
  logger.info(:action => 'read', :file_path => File.basename(file_path), :race_ids => race_ids)

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    next unless File.exists?(file_path)
    html = File.read(file_path)
    logger.info(:action => 'read', :resource => 'race', :file_path => File.basename(file_path))

    parsed_html = Nokogiri::HTML.parse(html)
    race_attribute = extract_race(parsed_html) rescue next

    race = Race.find_or_create_by!(race_attribute.merge(:race_id => race_id))
    logger.info(:action => 'create', :resource => 'race', :race_id => race_id)

    _, *rows = parsed_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      entry_attribute = extract_entry(row) rescue next
      entry = race.entries.find_or_create_by!(entry_attribute.except(:horse_id))
      logger.info(:action => 'create', :resource => 'entry', :race_id => race.race_id, :entry_id => entry.id)

      horse_id = entry_attribute[:horse_id]
      file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
      next unless File.exists?(file_path)
      html = File.read(file_path)
      logger.info(:action => 'read', :resource => 'horse', :file_path => File.basename(file_path))

      parsed_html = Nokogiri::HTML.parse(html)
      horse_attribute = extract_horse(parsed_html) rescue next
      horse = Horse.find_or_create_by!(horse_attribute.merge(:horse_id => horse_id))
      logger.info(:action => 'create', :resource => 'horse', :horse_id => horse_id)

      horse.entries << entry
    end
  end
end
