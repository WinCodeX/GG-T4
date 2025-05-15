# app/services/online_status_tracker.rb
class OnlineStatusTracker
  REDIS_KEY_PREFIX = "online_users"

  def self.mark_online(user_id)
    AppRedis.with do |conn|
      conn.set("#{REDIS_KEY_PREFIX}:#{user_id}", true, ex: 5.minutes.to_i)
    end
  end

  def self.mark_offline(user_id)
    AppRedis.with do |conn|
      conn.del("#{REDIS_KEY_PREFIX}:#{user_id}")
    end
  end

  def self.online?(user_id)
    AppRedis.with do |conn|
      conn.exists?("#{REDIS_KEY_PREFIX}:#{user_id}")
    end
  end
end