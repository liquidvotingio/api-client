require_relative 'support/vcr_setup'

# before(:suite) gets executed after the client is loaded and the 
# schema fetched, so we need to add the env vars on parsing
ENV['LIQUID_VOTING_API_URL'] = 'https://api.liquidvoting.io'
ENV['LIQUID_VOTING_API_AUTH_KEY'] = 'bc7eeccb-5e10-4004-8bfb-7fc68536bbd7'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
