require 'active_record'
require 'mysql2'
require_relative '../config/initialize'
require_relative '../lib/denebola_logger'

ActiveRecord::Base.logger = DenebolaLogger.new(Settings.logger.path.database)
ActiveRecord::Base.logger.level = Settings.logger.level.to_sym
settings = Settings.mysql.map {|key, value| [key.to_s, value] }.to_h.except('database')
settings.merge!('database' => Settings.mysql.database[ENV['RAILS_ENV']])
ActiveRecord::Base.establish_connection(settings)
