require "logger"
module SocketBroker
  struct Config
    property :bind, :port, :logger, :channel

    def initialize(@bind : String = "0.0.0.0", @port : Int32 = 8080, @channel : String = "crystal", @logger : Logger = Logger.new(STDOUT))

    end
  end

end
