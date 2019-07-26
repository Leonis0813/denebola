# coding: utf-8

def extract_payoff(html)
  payoff_tables = html.xpath('//dl[contains(@class, "pay_block")]').search('table')

  left_table = payoff_tables[0].search('tr')
  win_data = left_table.xpath('//tr/th[@class="tan"]').first&.parent
  show_data = left_table.xpath('//tr/th[@class="fuku"]').first&.parent
  bracket_quinella_data = left_table.xpath('//tr/th[@class="waku"]').first&.parent
  quinella_data = left_table.xpath('//tr/th[@class="uren"]').first&.parent

  right_table = payoff_tables[1].search('tr')
  quinella_places_data = right_table.xpath('//tr/th[@class="wide"]').first&.parent
  exacta_data = right_table.xpath('//tr/th[@class="utan"]').first&.parent
  trio_data = right_table.xpath('//tr/th[@class="sanfuku"]').first&.parent
  trifecta_data = right_table.xpath('//tr/th[@class="santan"]').first&.parent

  {
    win: extract_win(win_data&.search('td')),
    shows: extract_shows(show_data&.search('td')),
    bracket_quinella: extract_bracket_quinella(bracket_quinella_data&.search('td')),
    quinella: extract_quinella(quinella_data&.search('td')),
    quinella_places: extract_quinella_places(quinella_places_data&.search('td')),
    exacta: extract_exacta(exacta_data&.search('td')),
    trio: extract_trio(trio_data&.search('td')),
    trifecta: extract_trifecta(trifecta_data&.search('td')),
  }
end

def extract_win(tds)
  return unless tds

  {
    number: tds[0].text.to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_shows(tds)
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

def extract_bracket_quinella(tds)
  return unless tds

  entries = tds[0].text.split(' - ')
  {
    bracket_number1: entries[0].to_i,
    bracket_number2: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_quinella(tds)
  return unless tds

  entries = tds[0].text.split(' - ')
  {
    number1: entries[0].to_i,
    number2: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_quinella_places(tds)
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

def extract_exacta(tds)
  return unless tds

  entries = tds[0].text.split(' → ')
  {
    first_place_number: entries[0].to_i,
    second_place_number: entries[1].to_i,
    odds: tds[1].text.delete(',').to_f / 100,
    favorite: tds[2].text.to_i,
  }
end

def extract_trio(tds)
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

def extract_trifecta(tds)
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
