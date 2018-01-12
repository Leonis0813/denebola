# coding: utf-8
require_relative '../lib/mysql_client'

class Race
  attr_accessor :track, :direction, :distance, :weather, :place, :round, :start_time
  attr_accessor :entries

  def initialize(html)
    html.gsub!("\n", '')
    html.gsub!('&nbsp;', ' ')
    race_data = html.scan(/<dl class="racedata.*?\/dl>/).first
    condition = race_data.match(/<span>(.*)<\/span>/)[1].split(' / ')
    place = html.scan(/<ul class="race_place.*?<\/ul>/).first
    return unless condition.size == 4

    @track = condition.first[0].sub('ダ', 'ダート')
    @direction = condition.first[1]
    @distance = condition.first.match(/(\d*)m$/)[1].to_i
    @weather = condition[1].match(/天候 : (.*)/)[1]
    @place = place.match(/<a href=.* class="active">(.*?)<\/a>/)[1]
    @round = race_data.match(/<dt>(\d*) R<\/dt>/)[1].to_i

    start_time = condition[3].match(/発走 : (.*)/)[1]
    race_date = html.match(/<li class="result_link"><.*?>(\d*年\d*月\d*日)のレース結果<.*?>/)[1]
    race_date = race_date.gsub(/年|月/, '-').sub('日', '')
    @start_time = "#{race_date} #{start_time}:00"


    @entries = [].tap do |array|
      entries = html.scan(/<table class="race_table.*?<\/table>/).first.scan(/<tr>.*?<\/tr>/)
      entries.each {|entry| array << Entry.new(entry) }
    end
  end

  def save!
    client = MysqlClient.new
    id = client.insert(:races, [@track, @direction, @distance, @weather, @place, @round, @start_time])

    @entries.each do |entry|
      entry.race_id = id
      entry.save!
    end
  end
end
