require_relative '../db/connect'
require 'rspec-power_assert'

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
  config.include CommonHelper
end
