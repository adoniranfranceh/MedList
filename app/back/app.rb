require 'sinatra'
require 'pg'
require_relative 'models/patient'
require_relative 'jobs/csv_import_job'
require_relative 'helpers/csv_helper'

include CSVHelper

post '/import' do
  response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'

  begin
    file = params[:'csv-file'][:tempfile] if params[:'csv-file']
    raise 'Missing CSV file parameter.' unless file

    file_name = params[:'csv-file'][:filename]
    raise 'Invalid file format. Only CSV files are allowed.' unless csv_file?(file_name)

    file_path = save_temp_file(file)
    CSVImportWorker.perform_async(file_path)

    status 200
    body 'CSV file successfully imported.'
  rescue => e
    status 500
    body "Error importing CSV file: #{e.message}"
  end
end

get '/' do
  'Olá, acesse <a href="/tests">aqui</a> para obter a lista.'
end

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
  if params[:search]
    patients = Patient.search(params[:search])
    { patients: patients.map(&:to_hash) }.to_json
  else
    data = Patient.all.any? ? Patient.all.map(&:to_hash) : { message: 'Não há lista médica' }
    { patients: data }.to_json
  end
end

get '/tests/:token' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'

  patients = Patient.search_per_token(params['token'])
  { patients: patients.map(&:to_hash) }.to_json
end
