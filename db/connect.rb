require 'active_record'
require 'mysql2'
require_relative '../config/initialize'
require_relative '../lib/denebola_logger'

ActiveRecord::Base.logger = DenebolaLogger.new('log/database.log')
ActiveRecord::Base.establish_connection(Settings.mysql.to_h)
