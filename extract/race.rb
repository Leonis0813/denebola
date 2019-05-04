# coding: utf-8

def extract_race(html)
  {}.tap do |attribute|
    race_data = html.xpath('//dl[contains(@class, "racedata")]')

    track, weather, _, start_time, _ = race_data.search('span').text.split('/')
    attribute[:track] = track[0].sub('ダ', 'ダート')
    attribute[:direction] = track[1]
    attribute[:distance] = track.match(/(\d*)m/)[1].to_i
    attribute[:weather] = weather.match(/天候 : (.*)/)[1]
    attribute[:grade] = race_data.search('h1').text.match(/\((.*)\)$/).try(:[], 1)
    attribute[:place] = html.xpath('//ul[contains(@class, "race_place")]').first
                      .children[1].text.match(%r{<a.*class="active">(.*?)</a>})[1]
    attribute[:round] = race_data.search('dt').text.strip.match(/^(\d*) R$/)[1].to_i

    race_date = html.xpath('//li[@class="result_link"]').text.match(/(\d*年\d*月\d*日)のレース結果/)[1]
    race_date = race_date.gsub(/年|月/, '-').sub('日', '')
    start_time = start_time.match(/発走 : (.*)/)[1]
    attribute[:start_time] = "#{race_date} #{start_time}:00"
  end
end
