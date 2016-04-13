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

post '/message' do
  message = param[:message]
  header = {
    "Content-Type" => "application/json; charser=UTF-8",
    'X-Line-ChannelID' => ENV['channel_id'],
    'X-Line-ChannelSecret' => ENV['channel_secret'],
    'X-Line-Trusted-User-With-ACL' => ENV['channel_mid']
  }
  body = {
    to: ["送信相手のMID"],
    toChannel:1383378250,
    eventType:"138311608800106203",
    content:{contentType:1, toType:1, text: message }
  }

  uri = URI.parse('https://trialbot-api.line.me')
  client = Net::HTTP.new(uri.host, 443)
  client.use_ssl = true
  client.post("/v1/events", body.to_json, header)
end

