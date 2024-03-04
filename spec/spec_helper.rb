require 'simplecov'
require 'pg'

SimpleCov.start do
  add_filter '/spec/'
end

def create_test_database
  begin
    conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')
    conn.exec("CREATE DATABASE myapp_test") unless database_exists?(conn, 'myapp_test')
  ensure
    conn.close if conn
  end
end

def database_exists?(conn, dbname)
  result = conn.exec_params("SELECT COUNT(*) FROM pg_database WHERE datname = $1", [dbname])
  result[0]['count'].to_i > 0
end

create_test_database

require 'rack/test'
require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  config.before(:suite) do
    begin
      if @conn
        @conn.exec('ROLLBACK')
        @conn.close
      end

      conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

      conn.exec("DROP DATABASE IF EXISTS myapp_test")

      conn.close
    rescue PG::Error => e
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
