require 'mysql2'
require_relative '../config/settings'
require_relative '../lib/logger'

class MysqlClient
  def select(attributes, table, condition = 'TRUE')
    client = Mysql2::Client.new(Settings.mysql)
    results =client.query("SELECT #{attributes.join(',')} FROM #{table} WHERE #{condition}")
    client.close
    results
  end

  def insert(table, values)
    client = Mysql2::Client.new(Settings.mysql)
    values.map! {|value| value == 'NULL' ? 'NULL' : "'#{value}'" }
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

  def update(table, attributes, condition = 'TRUE')
    client = Mysql2::Client.new(Settings.mysql)
    set = attributes.map {|k, v| "`#{k}`='#{v}'" }
    client.query("UPDATE #{table} SET #{set.join(',')} WHERE #{condition}")
    client.close
  end
end
