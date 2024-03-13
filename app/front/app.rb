require 'sinatra'
require_relative 'fetch_patient'

get '/home' do
  content_type 'text/html'
  File.open('app/front/index.html')
end

get '/tests' do
  content_type :json
  return FetchPatient.search_per_name(params[:search]) if params[:search]
  FetchPatient.all
end

get '/tests/:token' do
  content_type :json
  FetchPatient.search_per_token(params[:token])
end

get '/main.js' do
  content_type 'application/javascript'
  File.open('app/front/main.js')
end

get '/styles.css' do
  content_type 'text/css'
  File.open('app/front/styles.css')
end

post '/import' do
  content_type :json
  p params.inspect
  FetchPatient.import(params[:'csv-file'][:tempfile])
end
