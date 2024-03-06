require 'sinatra'
require 'pg'
require_relative 'models/patient'

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'

  if params['search']
    patients = Patient.search(params['search'])
    { patients: patients.map(&:to_hash) }.to_json
  else
    data = Patient.all.any? ? Patient.all.map(&:to_hash) : { message: 'Não há lista médica' }
    { patients: data }.to_json
  end
end

get '/' do
  'Olá, acesse <a href="/tests">aqui</a> para obter a lista.'
end
