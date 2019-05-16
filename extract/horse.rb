# coding: utf-8

def extract_horse(html)
  {}.tap do |attribute|
    table = html.xpath('//table[contains(@class, "tekisei_table")]/tr')[2]
    bars = table.children.search('img').map do |img|
      [
        img.attribute('src').value.match(%r{([^/_]*).png})[1],
        img.attribute('width').value.to_i,
      ]
    end
    bars.delete_if {|bar| bar.first == 'centerline' }
    values = bars.map {|bar| bar.last }
    color = bars.first.first
    rate = values[0, 2].inject(:+).to_f / values.inject(:+).to_f

    attribute[:running_style] = if rate <= 0.25
                                  '追込'
                                elsif rate <= 0.5
                                  '先行'
                                elsif rate <= 0.75
                                  '差し'
                                else
                                  '逃げ'
                                end
  end
end
