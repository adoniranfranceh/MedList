require 'sinatra'
require 'pg'
require_relative 'models/patient'

get '/tests' do
  content_type :json
  data = Patient.all.any? ? Patient.all.map(&:to_hash) : { message: 'Não há lista médica' }
  { patients: data }.to_json
end

get '/' do
  'Olá, acesse <a href="/tests">aqui</a> para obter a lista.'
end