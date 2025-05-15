# app/services/online_status_tracker.rb
class OnlineStatusTracker
  REDIS_KEY_PREFIX = "online_users"

  def self.mark_online(user_id)
    Redis.current.set("#{REDIS_KEY_PREFIX}:#{user_id}", true, ex: 5.minutes)
  end

  def self.mark_offline(user_id)
    Redis.current.del("#{REDIS_KEY_PREFIX}:#{user_id}")
  end

  def self.online?(user_id)
    Redis.current.exists?("#{REDIS_KEY_PREFIX}:#{user_id}")
  end
end