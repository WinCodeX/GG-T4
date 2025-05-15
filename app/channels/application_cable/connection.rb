module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      OnlineStatusTracker.mark_online(current_user.id)
    end

    def disconnect
      OnlineStatusTracker.mark_offline(current_user.id)
    end

    protected

    def find_verified_user
      env['warden'].user || reject_unauthorized_connection
    end
  end
end