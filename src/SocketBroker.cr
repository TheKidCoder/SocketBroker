require "redis"
require "option_parser"
require "./SocketBroker/*"

module SocketBroker
end

config = SocketBroker::Config.new

OptionParser.parse! do |parser|
  parser.banner = "Usage: SocketBroker [arguments]"
  parser.on("-p", "--port", "Port to bind to") { |port| config.port = port.to_i }
  parser.on("-h", "--host", "Interface to bind to") { |host| config.bind = host.to_s }
  parser.on("--help", "--help", "Show this help") { puts parser; exit; }
end

config.logger.level = Logger::DEBUG



puts "Listening for websockets on interface: #{config.bind} port: #{config.port}"

server = SocketBroker::Server.new(config)
poller = SocketBroker::Poller.new("crystal") do |channel, message|
  config.logger.debug(message)
  server.broadcast(message)
end

spawn do
  server.start
end

poller.listen
# while true
  
# end


