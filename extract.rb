require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['extract/*'].each {|f| require_relative f }
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
logger = DenebolaLogger.new(Settings.logger.path.extract)
ArgumentUtil.logger = logger

def handle_active_record_error(logger, log_attribute)
  record = yield
  logger.info(log_attribute)
  record
rescue ActiveRecord::RecordInvalid => e
  logger.error(log_attribute.merge(errors: e.record.errors))
  raise
end

def update_race_info(html, race_id, logger)
  race_attribute = extract_race(html) rescue return
  log_attribute = Race.log_attribute.merge(race_id: race_id)
  handle_active_record_error(logger, log_attribute) do
    Race.create_or_update!(race_attribute.merge(race_id: race_id))
  end
end

def update_entry_info(attribute, logger)
  log_attribute = Entry.log_attribute.merge(attribute.slice(:race_id, :number))
  handle_active_record_error(logger, log_attribute) do
    Entry.create_or_update!(attribute)
  end
end

def update_jockey_info(jockey_id, race_id, logger)
  log_attribute = Jockey.log_attribute.merge(race_id: race_id, jockey_id: jockey_id)
  handle_active_record_error(logger, log_attribute) do
    Jockey.create_or_update!(jockey_id: jockey_id)
  end
end

def update_horse_info(horse_id, logger)
  file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
  return unless File.exist?(file_path)

  html = File.read(file_path, encoding: 'UTF-8')
  logger.info(action: 'read', resource: 'horse', file_path: File.basename(file_path))

  parsed_html = Nokogiri::HTML.parse(html)
  horse_attribute = extract_horse(parsed_html) rescue return
  log_attribute = Horse.log_attribute.merge(horse_id: horse_id)
  handle_active_record_error(logger, log_attribute) do
    Horse.create_or_update!(horse_attribute.merge(horse_id: horse_id))
  end
end

from = ArgumentUtil.get_from
to = ArgumentUtil.get_to
operation = ArgumentUtil.get_operation
check_operation(operation)

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
    race = update_race_info(race_html, race_id, logger)
    next if race.nil?

    _, *rows = race_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      entry_attribute = extract_entry(row) rescue next
      entry = update_entry_info(entry_attribute.merge(race_id: race.id), logger)
      jockey = update_jockey_info(entry_attribute[:jockey_id], race_id, logger)

      if jockey and entry
        jockey.results << entry
        entry.jockey = jockey
      end

      horse_id = entry_attribute[:horse_id]
      horse = update_horse_info(horse_id, logger)

      if horse and entry
        horse.results << entry
        entry.horse = horse
      end
    end

    payoff_attribute = extract_payoff(race_html)
    race.create_or_update_payoff(payoff_attribute.compact)
  end
end
