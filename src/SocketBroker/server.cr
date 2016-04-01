require "http/server"
require "colorize"

module SocketBroker
  class Server
    def initialize(config)
      @config = config
      @open_sockets = [] of HTTP::WebSocket
    end

    def start
      server.listen
    end

    def broadcast(message : String)
      @open_sockets.each {|sock| sock.send(message)}
    end

    def server
      @server ||= HTTP::Server.new(@config.bind, @config.port, handler_chain)
    end

    private def on_socket_open(socket)
      puts "Socket Open".colorize(:green)

      socket.on_message do |message|
        puts ["MSG RECIEVED".colorize(:green), message.colorize(:yellow)].join(" ## ")
      end

      socket.on_close do |message|
        puts "Socket ID: #{@open_sockets.index(socket)} - Closed".colorize(:red)
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