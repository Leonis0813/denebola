def extract_horse(html)
  {}.tap do |attribute|
    table = html.xpath('//table[contains(@class, "db_h_race_results")]')
    last_race, second_last_race, * = table.search('tbody').children.search('tr')
    last_race_order = last_race&.children&.search('td')[11].text.to_i
    last_race_final_600m_time = last_race&.children&.search('td')[22].text.to_f
    second_last_race_order = second_last_race&.children&.search('td')[11].text.to_i

    attribute[:last_race_order] = last_race_order unless last_race_order == 0
    unless second_last_race_order == 0
      attribute[:second_last_race_order] = second_last_race_order
    end
    unless last_race_final_600m_time == 0.0
      attribute[:last_race_final_600m_time] = last_race_final_600m_time
    end
  end
end
