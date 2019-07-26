require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['extract/*'].each {|f| require_relative f }
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
logger = DenebolaLogger.new(Settings.logger.path.extract)

def create_payoff(parsed_html, race)
  payoff_attribute = extract_payoff(parsed_html)

  race.create_win(payoff_attribute[:win]) unless race.win

  payoff_attribute[:shows].each do |show_attribute|
    race.shows.create!(show_attribute) unless race.shows.exists?(show_attribute)
  end

  bracket_quinella_attribute = payoff_attribute[:bracket_quinella]
  race.create_bracket_quinella(bracket_quinella_attribute) unless race.bracket_quinella

  quinella_attribute = payoff_attribute[:quinella]
  race.create_quinella(quinella_attribute) unless race.quinella

  payoff_attribute[:quinella_places].each do |quinella_place_attribute|
    unless race.quinella_places.exists?(quinella_place_attribute)
      race.quinella_places.create!(quinella_place_attribute)
    end
  end

  race.create_exacta(payoff_attribute[:exacta]) unless race.exacta

  race.create_trio(payoff_attribute[:trio]) unless race.trio

  race.create_trifecta(payoff_attribute[:trifecta]) unless race.trifecta
end

begin
  from = ARGV.find {|arg| arg.start_with?('--from=') }
  from = from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : (Date.today - 30)
  to = ARGV.find {|arg| arg.start_with?('--to=') }
  to = to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : Date.today
rescue ArgumentError => e
  logger.error(e.backtrace.join("\n"))
  raise e
end

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
  next unless File.exist?(file_path)

  race_ids = File.read(file_path).split("\n")
  logger.info(action: 'read', file_path: File.basename(file_path), race_ids: race_ids)

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    next unless File.exist?(file_path)

    html = File.read(file_path)
    logger.info(action: 'read', resource: 'race', file_path: File.basename(file_path))

    parsed_race_html = Nokogiri::HTML.parse(html)
    race_attribute = extract_race(parsed_race_html) rescue next

    race = Race.find_by(race_id: race_id)
    unless race
      base_log_attribute = {action: 'create', resource: 'race'}
      begin
        race = Race.create!(race_attribute.merge(race_id: race_id))
        logger.info(base_log_attribute.merge(race_id: race_id))
      rescue ActiveRecord::RecordInvalid => e
        logger.error(base_log_attribute.merge(errors: e.record.errors))
        raise
      end
    end

    _, *rows = parsed_race_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      entry_attribute = extract_entry(row) rescue next
      entry = race.entries.find_by(entry_attribute.slice(:race_id, :number))
      unless entry
        base_log_attribute = {action: 'create', resource: 'entry'}
        begin
          entry = race.entries.create!(entry_attribute.except(:horse_id))
          logger.info(
            base_log_attribute.merge(race_id: race.race_id, entry_id: entry.id),
          )
        rescue ActiveRecord::RecordInvalid => e
          logger.error(base_log_attribute.merge(errors: e.record.errors))
          raise
        end
      end

      horse_id = entry_attribute[:horse_id]
      file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
      next unless File.exist?(file_path)

      html = File.read(file_path)
      logger.info(action: 'read', resource: 'horse', file_path: File.basename(file_path))

      parsed_html = Nokogiri::HTML.parse(html)
      horse_attribute = extract_horse(parsed_html) rescue next
      horse = Horse.find_by(horse_id: horse_id)
      unless horse
        base_log_attribute = {action: 'create', resource: 'horse'}
        begin
          horse = Horse.create!(horse_attribute.merge(horse_id: horse_id))
          logger.info(base_log_attribute.merge(horse_id: horse_id))
        rescue ActiveRecord::RecordInvalid => e
          logger.error(base_log_attribute.merge(errors: e.record.errors))
          raise
        end
      end

      horse.results << entry
    end

    create_payoff(parsed_race_html, race)
  end
end
