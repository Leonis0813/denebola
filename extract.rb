require 'nokogiri'
require_relative 'config/initialize'
require_relative 'db/connect'
require_relative 'lib/denebola_logger'
Dir['extract/*'].each {|f| require_relative f }
Dir['models/concern/*'].each {|f| require_relative f }
Dir['models/*.rb'].each {|f| require_relative f }

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
logger = DenebolaLogger.new(Settings.logger.path.extract)

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

    race = Race.find_by(race_id: race_id)
    next if race.nil? and operation == 'update'

    if race
      if %w[update upsert].include?(operation)
        base_log_attribute = {action: 'update', resource: 'race'}
        begin
          race.update!(race_attribute.merge(race_id: race_id))
          logger.info(base_log_attribute.merge(race_id: race_id))
        rescue ActiveRecord::RecordInvalid => e
          logger.error(base_log_attribute.merge(errors: e.record.errors))
          raise
        end
      end
    else
      if %w[create upsert].include?(operation)
        base_log_attribute = {action: 'create', resource: 'race'}
        begin
          race = Race.create!(race_attribute.merge(race_id: race_id))
          logger.info(base_log_attribute.merge(race_id: race_id))
        rescue ActiveRecord::RecordInvalid => e
          logger.error(base_log_attribute.merge(errors: e.record.errors))
          raise
        end
      end
    end

    _, *rows = race_html.xpath('//table[contains(@class, "race_table")]').search('tr')
    rows.each do |row|
      entry_attribute = extract_entry(row) rescue next
      entry = race.entries.find_by(entry_attribute.slice(:race_id, :number))

      if entry
        if %w[update upsert].include?(operation)
          base_log_attribute = {action: 'update', resource: 'entry'}
          begin
            entry.update!(entry_attribute.except(:horse_id, :jockey_id))
            logger.info(
              base_log_attribute.merge(race_id: race.race_id, entry_id: entry.id),
            )
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      else
        if %w[create upsert].include?(operation)
          base_log_attribute = {action: 'create', resource: 'entry'}
          begin
            entry = race.entries.create!(entry_attribute.except(:horse_id, :jockey_id))
            logger.info(
              base_log_attribute.merge(race_id: race.race_id, entry_id: entry.id),
            )
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      end

      jockey = Jockey.find_by(jockey_id: entry_attribute[:jockey_id])

      if jockey
        if %w[update upsert].include?(operation)
          base_log_attribute = {action: 'update', resource: 'jockey'}
          begin
            jockey.update!(jockey_id: entry_attribute[:jockey_id])
            logger.info(
              base_log_attribute.merge(race_id: race.race_id, jockey_id: jockey.id),
            )
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      else
        if %w[create upsert].include?(operation)
          base_log_attribute = {action: 'create', resource: 'jockey'}
          begin
            jockey = Jockey.create!(jockey_id: entry_attribute[:jockey_id])
            logger.info(
              base_log_attribute.merge(race_id: race.race_id, jockey_id: jockey.id),
            )
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      end

      if entry
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
      horse = Horse.find_by(horse_id: horse_id)

      if horse
        if %w[update upsert].include?(operation)
          base_log_attribute = {action: 'update', resource: 'horse'}
          begin
            horse.update!(horse_attribute.merge(horse_id: horse_id))
            logger.info(base_log_attribute.merge(horse_id: horse_id))
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      else
        if %w[create upsert].include?(operation)
          base_log_attribute = {action: 'create', resource: 'horse'}
          begin
            horse = Horse.create!(horse_attribute.merge(horse_id: horse_id))
            logger.info(base_log_attribute.merge(horse_id: horse_id))
          rescue ActiveRecord::RecordInvalid => e
            logger.error(base_log_attribute.merge(errors: e.record.errors))
            raise
          end
        end
      end

      if entry
        horse.results << entry
        entry.horse = horse
      end
    end

    payoff_attribute = extract_payoff(race_html)
    race.create_payoff(payoff_attribute.compact)
  end
end
