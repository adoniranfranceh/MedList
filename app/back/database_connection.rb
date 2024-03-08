require 'pg'
require_relative 'helpers/database_helper'
ENV['RACK_ENV'] = 'development'

class DatabaseConnection
  extend DatabaseHelper 
  def self.connection
    connect_to_database(ENV['RACK_ENV'].to_sym)
  end
end
