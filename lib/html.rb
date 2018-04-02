# coding: utf-8
class HTML
  def self.parse(html)
    race = {}

    html.gsub!("\n", '')
    html.gsub!('&nbsp;', ' ')
    race_data = html.scan(/<dl class="racedata.*?\/dl>/).first
    condition = race_data.match(/<span>(.*)<\/span>/)[1].split(' / ')
    place = html.scan(/<ul class="race_place.*?<\/ul>/).first
    race[:grade] = race_data.match(/<h1>(.*?)</)[1].strip.match(/\((.*)\)$/)[1] rescue nil
    race[:track] = condition.first[0].sub('ダ', 'ダート')
    race[:direction] = condition.first[1]
    race[:distance] = condition.first.match(/(\d*)m$/)[1].to_i
    race[:weather] = condition[1].match(/天候 : (.*)/)[1]
    race[:place] = place.match(/<a href=.* class="active">(.*?)<\/a>/)[1]
    race[:round] = race_data.match(/<dt>(\d*) R<\/dt>/)[1].to_i

    start_time = condition[3].match(/発走 : (.*)/)[1]
    race_date = html.match(/<li class="result_link"><.*?>(\d*年\d*月\d*日)のレース結果<.*?>/)[1]
    race_date = race_date.gsub(/年|月/, '-').sub('日', '')
    race[:start_time] = "#{race_date} #{start_time}:00"

    entries = []
    entries_html = html.scan(/<table class="race_table.*?<\/table>/).first.scan(/<tr>.*?<\/tr>/)
    entries_html.each do |entry_html|
      attributes = entry_html.gsub(/<[\/]?tr>/, '').scan(/<td.*?>(.*?)<\/td>/).flatten
      attributes.map! {|attribute| attribute.gsub(/<.*?>/, '') }

      entry = {}
      entry[:number] = attributes[2].to_i
      entry[:age] = attributes[4].match(/(\d+)\z/)[1].to_i
      entry[:burden_weight] = attributes[5].to_f
      entry[:weight] = attributes[14] == '計不' ? nil : attributes[14].match(/\A(\d+)/)[1].to_f rescue nil
      entry[:weight_diff] = attributes[14] == '計不' ? nil : attributes[14].match(/\((.+)\)$/)[1].to_f rescue nil
      entry[:jockey] = attributes[6]
      entry[:result] = {:order => attributes[0]}
      entries << entry
    end

    race.merge(:entries => entries)
  end
end
