require 'mysql2'
require_relative '../config/settings'

class MysqlClient
  def execute_query(query, params = {})
    client = Mysql2::Client.new(Settings.mysql)
    params.each {|key, value| query.gsub!("{{#{key}}}", value) }
    client.query(query)
    client.close
  end
end
