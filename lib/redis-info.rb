require 'redis'

class RedisInfo
  
  def initialize(host='localhost', port=6379)
    @host = host
    @port = port
  end

  def master?
    role == 'master'
  end

  def slave?
    role == 'slave'
  end

  def slaveof
    connection do |redis|
      {:host => redis.info['master_host'], :port => redis.info['master_port']}
    end
  end

  def role
    connection do |redis|
      redis.info['role']
    end
  end
        
  protected

  def connection
    redis = Redis.new(:host => @host, :port => @port)
    yield(redis)
  end

end
