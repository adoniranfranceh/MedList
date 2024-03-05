require 'sinatra'

get '/home' do
  content_type 'text/html'
  File.open('app/front/index.html')
end

get '/main.js' do
  content_type 'application/javascript'
  File.open('app/front/main.js')
end
