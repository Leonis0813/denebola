require 'config'
require_relative '../lib/denebola_logger'
require_relative '../lib/argument_util'

APPLICATION_ROOT = File.expand_path(File.dirname('..'))
Config.load_and_set_settings(File.join(APPLICATION_ROOT, 'config/settings.yml'))
