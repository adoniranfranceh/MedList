require 'sinatra'
require 'pg'

conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

get '/tests' do
  result = conn.exec("SELECT * FROM patients")

  data = result.map { |row| row.to_h }

  content_type :json
  { patients: data }.to_json
end

get '/' do
  'Olá, acesse <a href="/tests">aqui</a> para obter a lista.'
end
