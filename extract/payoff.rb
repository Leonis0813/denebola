# coding: utf-8

def extract_payoff(html)
  payoff_tables = html.xpath('//dl[contains(@class, "pay_block")]').search('table')

  left_table = payoff_tables[0].search('tr')
  right_table = payoff_tables[1].search('tr')

  {
    win: extract_win(left_table),
    shows: extract_shows(left_table),
    bracket_quinella: extract_bracket_quinella(left_table),
    quinella: extract_quinella(left_table),
    quinella_places: extract_quinella_places(right_table),
    exacta: extract_exacta(right_table),
    trio: extract_trio(right_table),
    trifecta: extract_trifecta(right_table),
  }
end

def extract_win(table)
  tds = table.xpath('//tr/th[@class="tan"]').first&.parent&.search('td')
  return unless tds

  {
    number: tds[0].text.to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_shows(table)
  tds = table.xpath('//tr/th[@class="fuku"]').first&.parent&.search('td')
  return unless tds

  number_data = tds[0].children.reject {|data| data.text.empty? }
  odds_data = tds[1].children.reject {|data| data.text.empty? }
  favorite_data = tds[2].children.reject {|data| data.text.empty? }

  number_data.map.with_index do |number, i|
    {
      number: number.text.to_i,
      odds: odds_data[i].text.delete(',').to_f / 100,
      favorite: favorite_data[i].text.to_i,
    }
  end
end

def extract_bracket_quinella(table)
  tds = table.xpath('//tr/th[@class="waku"]').first&.parent&.search('td')
  return unless tds

  entries = tds[0].text.split(' - ')
  {
    bracket_number1: entries[0].to_i,
    bracket_number2: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_quinella(table)
  tds = table.xpath('//tr/th[@class="uren"]').first&.parent&.search('td')
  return unless tds

  entries = tds[0].text.split(' - ')
  {
    number1: entries[0].to_i,
    number2: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_quinella_places(table)
  tds = table.xpath('//tr/th[@class="wide"]').first&.parent&.search('td')
  return unless tds

  number_data = tds[0].children.reject {|data| data.text.empty? }
  odds_data = tds[1].children.reject {|data| data.text.empty? }
  favorite_data = tds[2].children.reject {|data| data.text.empty? }

  number_data.map.with_index do |number, i|
    entries = number.text.split(' - ')
    {
      number1: entries[0].to_i,
      number2: entries[1].to_i,
      odds: odds_data[i].text.delete(',').to_f / 100,
      favorite: favorite_data[i].text.to_i,
    }
  end
end

def extract_exacta(table)
  tds = table.xpath('//tr/th[@class="utan"]').first&.parent&.search('td')
  return unless tds

  entries = tds[0].text.split(' → ')
  {
    first_place_number: entries[0].to_i,
    second_place_number: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_trio(table)
  tds = table.xpath('//tr/th[@class="sanfuku"]').first&.parent&.search('td')
  return unless tds

  entries = tds[0].text.split(' - ')
  {
    number1: entries[0].to_i,
    number2: entries[1].to_i,
    number3: entries[2].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_trifecta(table)
  tds = table.xpath('//tr/th[@class="santan"]').first&.parent&.search('td')
  return unless tds

  entries = tds[0].text.split(' → ')
  {
    first_place_number: entries[0].to_i,
    second_place_number: entries[1].to_i,
    third_place_number: entries[2].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end
