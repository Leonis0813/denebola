# coding: utf-8

def extract_entry(html)
  {}.tap do |attribute|
    attributes = html.search('td').map(&:text).map(&:strip)
    horse_link = html.search('td')[3].first_element_child.attribute('href').value
    {
      :age => attributes[4].match(/(\d+)\z/)[1].to_i,
      :sex => attributes[4].match(/\A(.*)\d+/)[1],
      :burden_weight => attributes[5].to_f,
      :number => attributes[2].to_i,
      :weight => attributes[14].match(/\A(\d+)/).try(:[], 1).to_f,
      :weight_diff => attributes[14].match(/\((.+)\)$/).try(:[], 1).to_f,
      :jockey => attributes[6],
      :order => attributes[0],
      :horse_id => horse_link.match(/\/horse\/(?<horse_id>\d+)\/?/)[:horse_id]
    }
  end
end
