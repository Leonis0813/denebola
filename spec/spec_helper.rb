require_relative '../db/connect'
require 'database_cleaner'
require 'factory_bot'
require 'pry'
require 'rspec-power_assert'

require File.join(APPLICATION_ROOT, 'lib', 'collect_util')
Dir[File.join(APPLICATION_ROOT, 'models', '*.rb')].each {|f| require f }
Dir[File.join(APPLICATION_ROOT, 'spec', 'support', '**', '*.rb')].each {|f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.run_all_when_everything_filtered = true
  config.include FactoryBot::Syntax::Methods
  config.include CommonHelper

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
