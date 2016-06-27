module SocketBroker
  class Poller
    def initialize(@channel_name : String, &on_message : (String, String) ->)
      @on_message = on_message
      @redis = Redis.new
    end

    def listen
      @redis.subscribe(@channel_name) do |on|
        on.message do |channel, message|
          @on_message.call(channel, message)
        end
      end
    end
  end
end