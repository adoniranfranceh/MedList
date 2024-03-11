require 'pg'
require_relative 'helpers/database_helper'

class DatabaseConnection
  extend DatabaseHelper 
  def self.connection
    connect_to_database(:development)
  end
end
