require "redis"
require "./SocketBroker/*"

module SocketBroker
end

config = SocketBroker::Config.new

server = SocketBroker::Server.new(config)

puts "Listening for websockets on:#{config.bind} port:#{config.port}"

spawn do
  server.start
end

puts "WE OUT HERE"
while true
  sleep 2
  server.broadcast("From Crystal")
end


