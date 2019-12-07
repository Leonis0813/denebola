require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

class Extractor
  Dir['extract/*'].each {|f| require_relative f }
  BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

  include ArgumentUtil

  def self.work!
    logger = DenebolaLogger.new(Settings.logger.path.extract)
    extractor = new(logger)
    ArgumentUtil.logger = logger

    check_operation(operation)
    ApplicationRecord.operation = operation

    (from..to).each do |date|
      race_ids = extractor.fetch_race_ids(date)

      Array.wrap(race_ids).each do |race_id|
        race_html = extractor.fetch_race(race_id)
        race_html = Nokogiri::HTML.parse(race_html)
        next if race_html.nil?

        race = extractor.update_race_info(race_html, race_id)
        next if race.nil?

        _, *rows =
          race_html.xpath('//table[contains(@class, "race_table")]').search('tr')
        rows.each {|row| extractor.update_entry_info(row, race_id) rescue next }

        payoff_attribute = extract_payoff(race_html)
        race.create_or_update_payoff(payoff_attribute.compact)
      end
    end
  end

  def initialize(logger)
    @logger = logger
  end

  def fetch_race_ids(date)
    date = date.strftime('%Y%m%d')
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
    return unless File.exist?(file_path)

    race_ids = File.read(file_path).split("\n")
    @logger.info(action: 'read', file_path: "#{date}.txt", race_ids: race_ids)
    race_ids
  end

  def fetch_race(race_id)
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    return unless File.exist?(file_path)

    html = File.read(file_path, encoding: 'UTF-8')
    @logger.info(action: 'read', resource: 'race', file_path: "#{race_id}.html")
    html
  end

  def fetch_horse(horse_id)
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
    return unless File.exist?(file_path)

    html = File.read(file_path, encoding: 'UTF-8')
    @logger.info(action: 'read', resource: 'horse', file_path: "#{horse_id}.html")
    html
  end

  def update_race_info(html, race_id)
    attribute = extract_race(html) rescue return
    log_attribute = Race.log_attribute.merge(race_id: race_id)
    handle_active_record_error(log_attribute) do
      Race.create_or_update!(attribute.merge(race_id: race_id))
    end
  end

  def update_entry_info(html, race_id)
    attribute = extract_entry(html).merge(race_id: race_id)
    log_attribute = Entry.log_attribute.merge(attribute.slice(:race_id, :number))
    entry = handle_active_record_error(log_attribute) do
      Entry.create_or_update!(attribute)
    end
    entry.race = Race.find_by(race_id: race_id)
    jockey = update_jockey_info(attribute[:jockey_id], race_id)

    if jockey and entry
      jockey.results << entry
      entry.jockey = jockey
    end

    horse = update_horse_info(attribute[:horse_id])

    return unless horse and entry

    horse.results << entry
    entry.horse = horse
  end

  def update_jockey_info(jockey_id, race_id)
    log_attribute = Jockey.log_attribute.merge(race_id: race_id, jockey_id: jockey_id)
    handle_active_record_error(log_attribute) do
      Jockey.create_or_update!(jockey_id: jockey_id)
    end
  end

  def update_horse_info(horse_id)
    html = fetch_horse(horse_id)
    return if html.nil?

    html = Nokogiri::HTML.parse(html)
    attribute = extract_horse(html) rescue return
    log_attribute = Horse.log_attribute.merge(horse_id: horse_id)
    handle_active_record_error(log_attribute) do
      Horse.create_or_update!(attribute.merge(horse_id: horse_id))
    end
  end

  def handle_active_record_error(log_attribute)
    record = yield
    @logger.info(log_attribute)
    record
  rescue ActiveRecord::RecordInvalid => e
    @logger.error(log_attribute.merge(errors: e.record.errors))
    raise
  end
end

Extractor.work!
