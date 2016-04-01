require "logger"
module SocketBroker
  struct Config
    property :bind, :port, :logger

    def initialize(@bind : String = "0.0.0.0", @port : Int32 = 8080, @logger : Logger = Logger.new(STDOUT))
    end
  end

end