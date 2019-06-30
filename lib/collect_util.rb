require 'httpclient'

class CollectUtil
  cattr_accessor :logger
  cattr_accessor(:client) { HTTPClient.new }

  class << self
    def get_race_ids(race_ids_file, date)
      if File.exist?(race_ids_file)
        ids_from_file = File.read(race_ids_file).split("\n")
        logger.info(
          source: 'file',
          file_path: File.basename(race_ids_file),
          race_ids: ids_from_file,
        )
        ids_from_file
      else
        uri = "#{Settings.url}#{Settings.path.race_list}/#{date}"
        res = client.get(uri)
        ids_from_remote = res.body.scan(%r{.*/race/(\d+)}).flatten
        logger.info(
          source: 'web',
          uri: uri,
          status: res.code,
          race_ids: ids_from_remote,
        )
        File.open(race_ids_file, 'w') {|out| out.write(ids_from_remote.join("\n")) }
        ids_from_remote
      end
    end

    def get_race_html(race_html_file, race_id)
      if File.exist?(race_html_file)
        html_from_file = File.read(race_html_file)
        logger.info(
          resource: 'race',
          source: 'file',
          file_path: File.basename(race_html_file),
        )
        html_from_file
      else
        uri = "#{Settings.url}#{Settings.path.race}/#{race_id}"
        res = client.get(uri)
        logger.info(resource: 'race', souroce: 'web', uri: uri, status: res.code)
        options = {invalid: :replace, undef: :replace, replace: '?'}
        html_from_remote = res.body.encode('utf-8', 'euc-jp', options)
        html_from_remote.gsub!('&nbsp;', ' ')
        File.open(race_html_file, 'w') {|out| out.write(html_from_remote) }
        html_from_remote
      end
    end

    def get_horse_html(horse_html_file, horse_id)
      return if File.exist?(horse_html_file)

      uri = "#{Settings.url}#{Settings.path.horse}/#{horse_id}"
      res = client.get(uri)
      logger.info(resource: 'horse', source: 'web', uri: uri, status: res.code)
      options = {invalid: :replace, undef: :replace, replace: '?'}
      html = res.body.encode('utf-8', 'euc-jp', options)
      File.open(horse_html_file, 'w') {|out| out.write(html.gsub('&nbsp;', ' ')) }
    end
  end
end
