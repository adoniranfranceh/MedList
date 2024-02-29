require 'sinatra'
require 'pg'

conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

get '/tests' do
  result = conn.exec("SELECT * FROM USERS")

  data = result.map { |row| row.to_h }

  content_type :json
  data.to_json
end

get '/' do
  'Olá, acesse /tests para obter a lista'
end
