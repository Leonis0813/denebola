# coding: utf-8

def extract_entry(html)
  {}.tap do |attribute|
    attributes = html.search('td').map(&:text).map(&:strip)
    horse_link = html.search('td')[3].first_element_child.attribute('href').value

    attribute.merge!(
      age: attributes[4].match(/(\d+)\z/)[1].to_i,
      burden_weight: attributes[5].to_f,
      final_600m_time: attributes[12].to_f,
      horse_id: horse_link.match(%r{/horse/(?<horse_id>\d+)/?})[:horse_id],
      jockey: attributes[6],
      number: attributes[2].to_i,
      order: attributes[0],
      prize_money: attributes[20].delete(',').to_i * 10000,
      sex: attributes[4].match(/\A(.*)\d+/)[1],
      weight: attributes[14].match(/\A(\d+)/).try(:[], 1).to_f,
      weight_diff: attributes[14].match(/\((.+)\)$/).try(:[], 1).to_f,
    )
  end
end
