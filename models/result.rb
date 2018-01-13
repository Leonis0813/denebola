class Result
  attr_accessor :order, :race_id, :entry_id

  def initialize(attributes)
    @order = attributes[0]
  end

  def save!
    client = MysqlClient.new
    client.insert(:results, [@order, @race_id, @entry_id])
  end

  def self.find_by(condition)
    client = MysqlClient.new
    client.select(['*'], :results, condition.map {|k, v| "#{k}='#{v}'" }.join(' AND ') ).first
  end
end
