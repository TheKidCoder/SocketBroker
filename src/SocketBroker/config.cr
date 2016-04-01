module SocketBroker
  struct Config
    property :bind, :port

    def initialize(@bind : String = "0.0.0.0", @port : Int32 = 8080)
    end
  end

end