require_relative 'data_importer'
require_relative 'helpers/database_helper'
require_relative 'database_connection'

include DatabaseHelper

conn = DatabaseConnection.connection
create_schema(conn) unless schema_exists?(conn, 'public')
create_table(conn) unless table_exists?(conn, 'patients')
conn.close

include DataImporter
start_time = Time.now
DataImporter.import_from_csv('data/data.csv')
end_time = Time.now

puts "Tempo de execução: #{end_time - start_time} segundos"
