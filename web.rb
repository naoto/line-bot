require 'sinatra'
require 'json'

configure do
  @@message = []
end

post '/callback' do
  line_mes = JSON.parse(request.body.read)["result"][0]
  @@message << line_mes["content"]["text"]
end

get '/message' do
  text = @@message.to_json
  @@message = []
  text
end

