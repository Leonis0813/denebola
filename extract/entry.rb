# coding: utf-8

require_relative '../models/entry'

def extract_entry(html)
  attributes = html.search('td').map(&:text).map(&:strip)
  horse_link = html.search('td')[3].first_element_child.attribute('href').value
  weight, weight_diff = begin
                          attributes[14].match(/\A(\d+)\((.+)\)\z/)[1, 2].map(&:to_f)
                        rescue NoMethodError
                          [nil, nil]
                        end

  {
    age: attributes[4].match(/(\d+)\z/)[1].to_i,
    burden_weight: attributes[5].to_f,
    final_600m_time: attributes[12].to_f.zero? ? nil : attributes[12].to_f,
    horse_id: horse_link.match(%r{/horse/(?<horse_id>\d+)/?})[:horse_id],
    jockey: attributes[6],
    number: attributes[2].to_i,
    order: attributes[0].strip.match(/^(#{Entry::ORDER_LIST.join('|')})$/)[1],
    prize_money: attributes[20].delete(',').to_i * 10000,
    sex: attributes[4].match(/\A([^\d]*)\d+/)[1],
    weight: weight,
    weight_diff: weight_diff,
  }
end
