require 'httpclient'

class NetkeibaClient < HTTPClient
  def initialize(logger)
    super()
    @base_url = Settings.url
    @logger = logger
  end

  def http_get_race_ids(date)
    path = "#{Settings.path.race_list}/#{date}"
    response = get("#{@base_url}#{path}")
    options = {invalid: :replace, undef: :replace, replace: '?'}
    html = response.body.encode('utf-8', 'euc-jp', **options)
    html.gsub!('&nbsp;', ' ')
    race_ids = html.scan(%r{.*/race/(\d+)}).flatten
    @logger.info(path: path, status: response.code)
    race_ids
  end

  def http_get_race(race_id)
    path = "#{Settings.path.race}/#{race_id}"
    response = get("#{@base_url}#{path}")
    @logger.info(path: path, status: response.code)
    response.body
  end

  def http_get_horse(horse_id)
    path = "#{Settings.path.horse}/#{horse_id}"
    response = get("#{@base_url}#{path}")
    @logger.info(path: path, status: response.code)
    response.body
  end
end
