module MockPusherMacros
  def self.mock_pusher
    User::NOTIFICATION_SERVICE.instance_eval do
      def trigger(channel, event, data)
        # Do nothing
      end
    end
  end
end
