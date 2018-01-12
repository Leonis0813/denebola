class Result
  attr_accessor :order, :race_id, :entry_id

  def initialize(attributes, race_id, entry_id)
    @order = attributes[0]
    @race_id = race_id
    @entry_id = entry_id
  end

  def save!
    client = MysqlClient.new
    query = File.read('../sqls/collect/result.sql')
    client.execute_query(query, params)
  end
end
