require 'rubygems'
require 'websocket-client-simple'

ws = WebSocket::Client::Simple.connect 'http://localhost:9292'

hokkaido = '{
"name":"hirmatsu",
"lat":"43.063968",
"lon":"141.347899",
"vol":"3",
"type":"3"
}'

gifu = '{
"name":"hirmatsu",
"lat":"35.391227",
"lon":"136.722291",
"vol":"3",
"type":"3"
}'

ws.on :message do |msg|
      p msg.data
end

ws.on :open do
      ws.send gifu
end

ws.on :close do |e|
      p e
            exit 1
end

loop do
#      ws.send STDIN.gets.strip
end
