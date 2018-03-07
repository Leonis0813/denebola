require 'active_record'
require 'config'
require 'mysql2'

config_path = File.join(File.expand_path(File.dirname('..')), 'config/settings.yml')
Config.load_and_set_settings(config_path)
ActiveRecord::Base.establish_connection(Settings.mysql.to_h)
