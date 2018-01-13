# coding: utf-8
require_relative '../lib/mysql_client'

class Entry
  attr_accessor :number, :age, :burden_weight, :weight, :race_id
  attr_accessor :result

  def initialize(html)
    attributes = html.gsub(/<[\/]?tr>/, '').scan(/<td.*?>(.*?)<\/td>/).flatten
    attributes.map! {|attribute| attribute.gsub(/<.*?>/, '') }

    @number = attributes[2].to_i
    @age = attributes[4].match(/(\d+)\z/)[1].to_i
    @burden_weight = attributes[5].to_f
    @weight = attributes[14] == '計不' ? 'NULL' : features[14].match(/\A(\d+)/)[1].to_f rescue 'NULL'
    @result = Result.new(attributes)
  end

  def save!
    client = MysqlClient.new
    id = client.insert(:entries, [@number, @age, @burden_weight, @weight, @race_id])

    @result.race_id = @race_id
    @result.entry_id = id
    @result.save!
  end

  def self.find(id)
    client = MysqlClient.new
    client.select(['*'], :entries, "id = #{id}")
  end
end
