# coding: utf-8

def extract_entry(html)
  {}.tap do |attribute|
    attributes = html.search('td').map(&:text).map(&:strip)
    horse_link = html.search('td')[3].first_element_child.attribute('href').value

    attribute[:age] = attributes[4].match(/(\d+)\z/)[1].to_i
    attribute[:burden_weight] = attributes[5].to_f
    attribute[:final_600m_time] = attributes[12].to_f
    attribute[:horse_id] = horse_link.match(%r{/horse/(?<horse_id>\d+)/?})[:horse_id]
    attribute[:jockey] = attributes[6]
    attribute[:number] = attributes[2].to_i
    attribute[:order] = attributes[0]
    attribute[:prize_money] = attributes[20].delete(',').to_i * 10000
    attribute[:sex] = attributes[4].match(/\A(.*)\d+/)[1]
    attribute[:weight] = attributes[14].match(/\A(\d+)/).try(:[], 1).to_f
    attribute[:weight_diff] = attributes[14].match(/\((.+)\)$/).try(:[], 1).to_f
  end
end
