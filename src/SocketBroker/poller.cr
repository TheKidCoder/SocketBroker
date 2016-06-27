module SocketBroker
  class Poller
    def initialize(@config : SocketBroker::Config, &@on_message : (String, String) ->)
      @redis = Redis.new
    end

    def listen
      @redis.subscribe(@config.channel) do |on|
        on.message do |channel, message|
          @on_message.call(@config.channel, message)
        end
      end
    end
  end
end
