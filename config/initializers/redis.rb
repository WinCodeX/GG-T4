# config/initializers/redis.rb
require 'redis'
require 'connection_pool'

RedisClient = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })
end