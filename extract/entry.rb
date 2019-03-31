# coding: utf-8

def extract_entry(html)
  {}.tap do |attribute|
    attributes = html.search('td').map(&:text).map(&:strip)
    horse_link = html.search('td')[3].first_element_child.attribute('href').value
    attribute[:age] = attributes[4].match(/(\d+)\z/)[1].to_i
    attribute[:sex] = attributes[4].match(/\A(.*)\d+/)[1]
    attribute[:burden_weight] = attributes[5].to_f
    attribute[:number] = attributes[2].to_i
    attribute[:weight] = attributes[14].match(/\A(\d+)/).try(:[], 1).to_f
    attribute[:weight_diff] = attributes[14].match(/\((.+)\)$/).try(:[], 1).to_f
    attribute[:jockey] = attributes[6]
    attribute[:order] = attributes[0]
    attribute[:horse_id] = horse_link.match(/\/horse\/(?<horse_id>\d+)\/?/)[:horse_id]
  end
end
