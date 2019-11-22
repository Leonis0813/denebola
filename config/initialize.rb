require 'config'

APPLICATION_ROOT = File.expand_path(File.dirname('..'))
VALID_OPERATIONS = %w[create update upsert]
Config.load_and_set_settings(File.join(APPLICATION_ROOT, 'config/settings.yml'))
