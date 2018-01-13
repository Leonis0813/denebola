require_relative '../lib/mysql_client'

class Feature
  attr_accessor :track, :direction, :distance, :weather, :place, :round,
                :number, :age, :burden_weight, :weight,
                :order,
                :race_id, :entry_id

  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value) }
  end

  def save!
    client = MysqlClient.new
    client.insert(:features, ['NULL'] * 11 + [@race_id, @entry_id])
  end

  def update!(attributes)
    client = MysqlClient.new
    client.update(:features, attributes, "race_id = #{@race_id} AND entry_id = #{@entry_id}")
  end
end
