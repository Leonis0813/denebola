def extract_horse(html)
  {}.tap do |attribute|
    table = html.xpath('//table[contains(@class, "db_h_race_results")]')
    results = table.search('tbody').children.search('tr').children.search('td')
    last_race, second_last_race, * = results.map(&:text).map {|text| text.delete("\n") }

    attribute[:last_race_order] = last_race[11] if last_race
    attribute[:second_last_race_order] = second_last_race[11] if second_last_race
    attribute[:last_race_final_600m_time] = last_race[22] if last_race
  end
end
