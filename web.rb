require 'sinatra'
require 'json'

configure do
  @@message = []
  @@mid = "uba1db1335da6f532ba1c981bd686da30"
end

post '/callback' do
  line_mes = JSON.parse(request.body.read)["result"][0]
  @@mid = line_mes['from']
  puts line_mes
  @@message << line_mes["content"]["text"]
end

get '/message' do
  text = @@message.to_json
  @@message = []
  text
end

post '/message' do
  message = params['message']
  header = {
    "Content-Type" => "application/json; charser=UTF-8",
    'X-Line-ChannelID' => ENV['channel_id'].to_s,
    'X-Line-ChannelSecret' => ENV['channel_secret'].to_s,
    'X-Line-Trusted-User-With-ACL' => ENV['channel_mid'].to_s
  }
  puts "mid => #{@@mid}"
  body = {
    to: [@@mid],
    toChannel: 1383378250,
    eventType:"138311608800106203",
    content:{contentType:1, toType:1, text: message }
  }

  uri = URI.parse('https://trialbot-api.line.me')
  client = Net::HTTP.new(uri.host, 443)
  client.use_ssl = true
  result = client.post("/v1/events", body.to_json, header)
  result.inspect
end

