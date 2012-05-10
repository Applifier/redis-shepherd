require 'redis'

class RedisStatus
  
  def initialize(host, port)
    @host = host
    @port = port
    @redis = Redis.new(:host => @host, :port => @port)
  end

  def master?
    @redis.info['role'] == 'master'
  end

  def slave?
    @redis.info['role'] == 'slave'
  end

  def slaveof
    {:host => @redis.info['master_host'], :port => @redis.info['master_port']}
  end
  
end