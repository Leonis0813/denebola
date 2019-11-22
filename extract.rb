require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['extract/*'].each {|f| require_relative f }
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
logger = DenebolaLogger.new(Settings.logger.path.extract)

def handle_active_record_error(logger, log_attribute)
  record = yield
  logger.info(log_attribute)
  record
rescue ActiveRecord::RecordInvalid => e
  logger.error(log_attribute.merge(errors: e.record.errors))
  raise
end

begin
  from = ARGV.find {|arg| arg.start_with?('--from=') }
  from = from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : (Date.today - 30)
  to = ARGV.find {|arg| arg.start_with?('--to=') }
  to = to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : Date.today
  operation = ARGV.find {|arg| arg.start_with?('--operation=') }
  operation = operation ? operation.match(/\A--operation=(.*)\z/)[1] : 'create'
rescue ArgumentError => e
  logger.error(e.backtrace.join("\n"))
  raise
end

unless VALID_OPERATIONS.include?(operation)
  logger.error("invalid operation specified: #{operation}")
  return
end

ApplicationRecord.operation = operation

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
  next unless File.exist?(file_path)

  race_ids = File.read(file_path).split("\n")
  logger.info(action: 'read', file_path: File.basename(file_path), race_ids: race_ids)

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    next unless File.exist?(file_path)

    html = File.read(file_path, encoding: 'UTF-8')
    logger.info(action: 'read', resource: 'race', file_path: File.basename(file_path))

    race_html = Nokogiri::HTML.parse(html)
    race_attribute = extract_race(race_html) rescue next
    log_attribute = Race.log_attribute.merge(race_id: race_id)
    race = handle_active_record_error(logger, log_attribute) do
      Race.create_or_update!(race_attribute.merge(race_id: race_id))
    end

    next if race.nil?

    _, *rows = race_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      entry_attribute = extract_entry(row) rescue next
      log_attribute = Entry.log_attribute.merge(
        race_id: race_id,
        number: entry_attribute[:number],
      )
      entry = handle_active_record_error(logger, log_attribute) do
        Entry.create_or_upsert!(entry_attribute)
      end

      log_attribute = Jockey.log_attribute.merge(
        race_id: race_id,
        jockey_id: entry_attribute[:jockey_id],
      )
      jockey = handle_active_record_error(logger, log_attribute) do
        Jockey.create_or_update!(jockey_id: entry_attribute[:jockey_id])
      end

      if jockey and entry
        jockey.results << entry
        entry.jockey = jockey
      end

      horse_id = entry_attribute[:horse_id]
      file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
      next unless File.exist?(file_path)

      html = File.read(file_path, encoding: 'UTF-8')
      logger.info(action: 'read', resource: 'horse', file_path: File.basename(file_path))

      parsed_html = Nokogiri::HTML.parse(html)
      horse_attribute = extract_horse(parsed_html) rescue next
      log_attribute = Horse.log_attribute.merge(horse_id: horse_id)
      horse = handle_active_record_error(logger, log_attribute) do
        Horse.create_or_update!(horse_attribute.merge(horse_id: horse_id))
      end

      if horse and entry
        horse.results << entry
        entry.horse = horse
      end
    end

    payoff_attribute = extract_payoff(race_html)
    race.create_payoff(payoff_attribute.compact)
  end
end
