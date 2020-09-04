require 'active_support'
require 'nokogiri'
require_relative 'config/initialize'
require_relative 'lib/netkeiba_client'

class Collector
  BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')

  include ArgumentUtil

  class << self
    def work!
      logger = DenebolaLogger.new(Settings.logger.path.collect)
      collector = new(logger)
      collector.remove_empty_files

      (from..to).each do |date|
        race_ids = collector.fetch_race_ids(date)

        race_ids.each do |race_id|
          race_html = collector.fetch_race(race_id)
          parsed_html = Nokogiri::HTML.parse(race_html)

          _, *entries =
            parsed_html.xpath('//table[contains(@class, "race_table")]').search('tr')

          entries.each do |entry|
            horse_link =
              entry.search('td')[3].first_element_child.attribute('href').value
            horse_id = horse_link.match(%r{/horse/(?<horse_id>\d+)/?})[:horse_id]
            collector.fetch_horse(horse_id)
          end
        end
      end
    rescue ArgumentError => e
      logger.error(e.backtrace.join("\n"))
      raise
    end

    def from
      super.blank? ? Date.today - 30 : Date.parse(super)
    end

    def to
      super.blank? ? Date.today : Date.parse(super)
    end
  end

  def initialize(logger)
    @logger = logger
    @client = NetkeibaClient.new(logger)
  end

  def fetch_race_ids(date)
    date = date.strftime('%Y%m%d')
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")

    if File.exist?(file_path)
      race_ids = File.read(file_path).split("\n")
      @logger.info(source: 'file', file_path: "#{date}.txt", race_ids: race_ids)
    else
      race_ids = @client.http_get_race_ids(date)
      File.open(file_path, 'w') {|file| file.write(race_ids.join("\n")) }
      @logger.info(source: 'web', file_path: "#{date}.txt", race_ids: race_ids)
    end

    race_ids
  end

  def fetch_race(race_id)
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")

    if File.exist?(file_path)
      html = File.read(file_path)
      @logger.info(resource: 'race', source: 'file', file_path: "#{race_id}.html")
    else
      html = @client.http_get_race(race_id)
      options = {invalid: :replace, undef: :replace, replace: '?'}
      html = html.encode('utf-8', 'euc-jp', options)
      html.gsub!('&nbsp;', ' ')
      File.open(file_path, 'w') {|file| file.write(html) }
      @logger.info(resource: 'race', souroce: 'web', file_path: file_path)
    end

    html
  end

  def fetch_horse(horse_id)
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")

    return if File.exist?(file_path)

    html = @client.http_get_horse(horse_id)
    options = {invalid: :replace, undef: :replace, replace: '?'}
    html = html.encode('utf-8', 'euc-jp', options)
    html.gsub!('&nbsp;', ' ')
    File.open(file_path, 'w') {|file| file.write(html) }
    @logger.info(resource: 'horse', souroce: 'web', file_path: file_path)
  end

  def remove_empty_files
    Settings.backup_dir.to_h.values.each do |path|
      target_dir = File.join(BACKUP_DIR, path)
      FileUtils.mkdir_p(target_dir)
      removed_files = Dir[File.join(target_dir, '*')].select do |file_path|
        File.zero?(file_path)
      end
      FileUtils.rm(removed_files) if removed_files
    end
  end
end

Collector.work!
