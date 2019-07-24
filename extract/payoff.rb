# coding: utf-8

def extract_payoff(html)
  payoff_data = html.xpath('//dl[contains(@class, "pay_block")]')

  win_data = payoff_data.search('table').first.search('tr')[0].search('td')
  show_data = payoff_data.search('table').first.search('tr')[1].search('td')
  bracket_quinella_data = payoff_data.search('table').first.search('tr')[2].search('td')
  quinella_data = payoff_data.search('table').first.search('tr')[3].search('td')

  quinella_places_data = payoff_data.search('table').second.search('tr')[0].search('td')
  exacta_data = payoff_data.search('table').second.search('tr')[1].search('td')

  {
    win: extract_win(win_data),
    shows: extract_shows(show_data),
    bracket_quinella: extract_bracket_quinella(bracket_quinella_data),
    quinella: extract_quinella(quinella_data),
    quinella_places: extract_quinella_places(quinella_places_data),
    exacta: extract_exacta(exacta_data),
    trio: extract_trio(trio_data),
    trifecta: extract_trifecta(trifecta_data),
  }
end

def extract_win(td)
  {
    number: td.first.text.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end

def extract_shows(td)
  number_data = td.first.children.select {|data| not data.text.empty? }
  odds_data = td.second.children.select {|data| not data.text.empty? }
  favorite_data = td.third.children.select {|data| not data.text.empty? }

  number_data.map.with_index do |number, i|
    {
      number: number.text.to_i,
      odds: odds_data[i].text.delete(',').to_f / 100,
      favorite: favorite_data[i].text.to_i,
    }
  end
end

def extract_bracket_quinella(td)
  entries = td.first.text.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end

def extract_quinella(td)
  entries = td.first.text.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end

def extract_quinella_places(td)
  number_data = td.first.children.select {|data| not data.text.empty? }
  odds_data = td.second.children.select {|data| not data.text.empty? }
  favorite_data = td.third.children.select {|data| not data.text.empty? }

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

def extract_exacta(td)
  entries = td.first.split(' → ')
  {
    first_place: entries.first.to_i,
    second_place: entries.second.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end

def extract_trio(td)
  entries = td.first.split(' - ')
  {
    entry1: entries.first.to_i,
    entry2: entries.second.to_i,
    entry3: entries.third.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end

def extract_trifecta(td)
  entries = td.first.split(' → ')
  {
    first_place: entries.first.to_i,
    second_place: entries.second.to_i,
    third_place: entries.third.to_i,
    odds: td.second.text.delete(',').to_f / 100,
    favorite: td.third.text.to_i,
  }
end
