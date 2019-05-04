require 'httpclient'
require 'nokogiri'
require_relative 'config/initialize'
require_relative 'lib/denebola_logger'

BACKUP_DIR = File.join(APPLICATION_ROOT, 'backup')
client = HTTPClient.new
logger = DenebolaLogger.new(Settings.logger.path.collect)

begin
  from = ARGV.find {|arg| arg.start_with?('--from=') }
  from = from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : (Date.today - 30)
  to = ARGV.find {|arg| arg.start_with?('--to=') }
  to = to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : Date.today
rescue Exception => e
  logger.error(e.backtrace.join("\n"))
  raise e
end

Settings.backup_dir.to_h.values.each do |path|
  FileUtils.mkdir_p(File.join(BACKUP_DIR, path))
  removed_files = Dir[File.join(BACKUP_DIR, path, '*')].select do |file_path|
    File.zero?(file_path)
  end
  FileUtils.rm(removed_files) if removed_files
end

(from..to).each do |date|
  date = date.strftime('%Y%m%d')

  file_path = File.join(BACKUP_DIR, Settings.backup_dir.race_list, "#{date}.txt")
  race_ids = if File.exists?(file_path)
               ids = File.read(file_path).split("\n")
               logger.info(source: 'file', file_path: File.basename(file_path), race_ids: ids)
               ids
             else
               uri = "#{Settings.url}#{Settings.path.race_list}/#{date}"
               res = client.get(uri)
               ids = res.body.scan(%r[.*/race/(\d+)]).flatten
               logger.info(source: 'web', uri: uri, status: res.code, race_ids: ids)
               File.open(file_path, 'w') {|out| out.write(ids.join("\n")) }
               ids
             end

  race_ids.each do |race_id|
    file_path = File.join(BACKUP_DIR, Settings.backup_dir.race, "#{race_id}.html")
    html = if File.exists?(file_path)
             html = File.read(file_path)
             logger.info(resource: 'race', source: 'file', file_path: File.basename(file_path))
             html
           else
             uri = "#{Settings.url}#{Settings.path.race}/#{race_id}"
             res = client.get(uri)
             logger.info(resource: 'race', souroce: 'web', uri: uri, status: res.code)
             html = res.body.encode('utf-8', 'euc-jp', undef: :replace, replace: '?')
             html.gsub!('&nbsp;', ' ')
             File.open(file_path, 'w') {|out| out.write(html) }
             html
           end

    parsed_html = Nokogiri::HTML.parse(html)
    _, *entries = parsed_html.xpath('//table[contains(@class, "race_table")]').search('tr')

    entries.each do |entry|
      horse_link = entry.search('td')[3].first_element_child.attribute('href').value
      horse_id = horse_link.match(/\/horse\/(?<horse_id>\d+)\/?/)[:horse_id]

      file_path = File.join(BACKUP_DIR, Settings.backup_dir.horse, "#{horse_id}.html")
      unless File.exists?(file_path)
        uri = "#{Settings.url}#{Settings.path.horse}/#{horse_id}"
        res = client.get(uri)
        logger.info(resource: 'horse', source: 'web', uri: uri, status: res.code)
        html = res.body.encode('utf-8', 'euc-jp', undef: :replace, replace: '?')
        File.open(file_path, 'w') {|out| out.write(html.gsub('&nbsp;', ' ')) }
      end
    end
  end
end
