# coding: utf-8

def extract_payoff(html)
  payoff_tables = html.xpath('//dl[contains(@class, "pay_block")]').search('table')

  win_data, show_data, bracket_quinella_data, quinella_data =
    payoff_tables.first.search('tr')

  quinella_places_data, exacta_data, trio_data, trifecta_data =
    payoff_tables.second.search('tr')

  {
    win: extract_win(win_data.search('td')),
    shows: extract_shows(show_data.search('td')),
    bracket_quinella: extract_bracket_quinella(bracket_quinella_data.search('td')),
    quinella: extract_quinella(quinella_data.search('td')),
    quinella_places: extract_quinella_places(quinella_places_data.search('td')),
    exacta: extract_exacta(exacta_data.search('td')),
    trio: extract_trio(trio_data.search('td')),
    trifecta: extract_trifecta(trifecta_data.search('td')),
  }
end

def extract_win(tds)
  {
    number: tds.first.text.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end

def extract_shows(tds)
  number_data = tds.first.children.reject {|data| data.text.empty? }
  odds_data = tds.second.children.reject {|data| data.text.empty? }
  favorite_data = tds.third.children.reject {|data| data.text.empty? }

  number_data.map.with_index do |number, i|
    {
      number: number.text.to_i,
      odds: odds_data[i].text.delete(',').to_f / 100,
      favorite: favorite_data[i].text.to_i,
    }
  end
end

def extract_bracket_quinella(tds)
  entries = tds.first.text.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end

def extract_quinella(tds)
  entries = tds.first.text.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end

def extract_quinella_places(tds)
  number_data = tds.first.children.reject {|data| data.text.empty? }
  odds_data = tds.second.children.reject {|data| data.text.empty? }
  favorite_data = tds.third.children.reject {|data| data.text.empty? }

  number_data.map.with_index do |number, i|
    entries = number.text.split(' - ')
    {
      entry1: entries.first.to_i,
      entry2: entries.second.to_i,
      odds: odds_data[i].text.delete(',').to_f / 100,
      favorite: favorite_data[i].text.to_i,
    }
  end
end

def extract_exacta(tds)
  entries = tds.first.split(' → ')
  {
    first_place: entries.first.to_i,
    second_place: entries.second.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end

def extract_trio(tds)
  entries = tds.first.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    entry3: entries.third.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end

def extract_trifecta(tds)
  entries = tds.first.split(' → ')
  {
    first_place: entries.first.to_i,
    second_place: entries.second.to_i,
    third_place: entries.third.to_i,
    odds: tds.second.text.delete(',').to_f / 100,
    favorite: tds.third.text.to_i,
  }
end
