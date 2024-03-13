require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

ENV['RACK_ENV'] = 'test'

require 'pg'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/cuprite'

require_relative '../app/back/app'
require_relative '../app/front/app'

require 'reset_database'
require_relative 'database_setup'


Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    browser_options: { 'no-sandbox': nil },
    inspector: true,
    base_url: 'http://app_front:3000'
  )
end

Capybara.javascript_driver = :cuprite

#,  logger: STDOUT

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.include Capybara::DSL

  config.include DatabaseHelper

  config.before(:each) do
    conn = connect_to_database(ENV['RACK_ENV'].to_sym)

    database_setup(conn)
  end

  config.after(:each) do
    connection_test = 'test'
    if ENV['RACK_ENV'] == connection_test
      conn = connect_to_database(ENV['RACK_ENV'].to_sym)
      reset_database(conn, 'patients')
    end
  end

  def app
    Sinatra::Application
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
