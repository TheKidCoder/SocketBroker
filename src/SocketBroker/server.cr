require "http/server"
require "colorize"

module SocketBroker
  class Server
    def initialize(config : SocketBroker::Config)
      @config = config
      @open_sockets = [] of HTTP::WebSocket
      @redis = Redis.new
    end

    def start
      server.listen
    end

    def broadcast(message : String)
      @open_sockets.each { |sock| sock.send(message) }
    end

    def server
      @server ||= HTTP::Server.new(@config.bind, @config.port, handler_chain)
    end

    private def on_socket_open(socket)
      @config.logger.debug "Socket Open".colorize(:green)
      socket.on_message do |message|
        @config.logger.debug ["MSG RECIEVED".colorize(:green), message.colorize(:yellow)].join(" ## ")
        @redis.publish @config.channel, message
      end

      socket.on_close do |message|
        @config.logger.debug "Socket ID: #{@open_sockets.index(socket)} - Closed".colorize(:red)
        @open_sockets.delete(socket)
      end

      @open_sockets << socket
    end

    private def handler_chain
      [
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::WebSocketHandler.new {|socket, context| on_socket_open(socket)}
      ]
    end
  end
end
