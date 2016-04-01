module SocketBroker
  class Poller
    def initialize
      @redis = Redis.new
    end
  end
end