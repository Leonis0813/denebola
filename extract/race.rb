# coding: utf-8

def extract_race(html)
  race_data = html.xpath('//dl[contains(@class, "racedata")]')

  track, weather, _, start_time, = race_data.search('span').text.split('/')
  race_date = html.xpath('//li[@class="result_link"]').text
                  .match(/(\d*)年(\d*)月(\d*)日のレース結果/)
  race_name = race_data.search('h1').text

  {
    direction: track[1] == '芝' ? '障' : track[1],
    distance: track.match(/(\d*)m/)[1].to_i,
    grade: race_name.match(/\(([^\(\)]*)\)$/).try(:[], 1),
    place: html.xpath('//ul[contains(@class, "race_place")]').first
               .children[1].text.match(%r{<a.*class="active">(.*?)</a>})[1],
    race_name: race_name,
    round: race_data.search('dt').text.strip.match(/^(\d*) R$/)[1].to_i,
    start_time: "#{race_date[1]}-#{race_date[2]}-#{race_date[3]} " \
                "#{start_time.match(/発走 : (.*)/)[1]}:00",
    track: track[0].sub('ダ', 'ダート'),
    weather: weather.match(/天候 : (.*)/)[1].strip,
  }
end
