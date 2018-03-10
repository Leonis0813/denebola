require 'config'

CONFIG_PATH_path = File.join(File.expand_path(File.dirname('..')), 'config/settings.yml')
Config.load_and_set_settings(CONFIG_PATH)
