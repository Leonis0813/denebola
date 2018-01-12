require 'mysql2'
require_relative '../config/settings'

class MysqlClient
  def insert(table, values)
    client = Mysql2::Client.new(Settings.mysql)
    values.map! {|value| "'#{value}'" }
    client.query("INSERT IGNORE INTO #{table} VALUES (NULL,#{values.join(',')})")
    id = client.last_id
    if id == 0
      Logger.info(:action => 'insert', :table => table, :message => 'already_exist')
    else
      Logger.info(:action => 'insert', :table => table, :id => id, :values => values)
    end
    client.close
    id
  end
end
