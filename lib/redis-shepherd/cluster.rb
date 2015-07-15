module RedisShepherd
  
  class Cluster

    def initialize(config)
      @cname = config[:dns][:cname]
      @redises = config[:redises]
      @dryrun = config[:dryrun]
      @log = Logger.new(config[:logfile] || STDOUT)
      @log.level = Logger::INFO

      @dns = RedisShepherd::DNS.new(config[:dns][:config])
    end

    def shepherd
      @log.info "Shepharding #{@cname}#{', but not really doing anything, I just like to watch' if @dryrun}"

      # See where the CNAME points at the moment
      cname = self.cname

      # Create list of running master(s) and slaves
      masters, slaves = self.members

      # All servers down, nothing we can do
      if masters.empty? and slaves.empty?
        @log.warn "All servers are DOWN"
        return
      end

      # No running slaves, nothing we can do but continue searching for running master(s)
      @log.warn "Redis slave(s) DOWN" if slaves.empty?

      # No running master
      if masters.empty?
        @log.warn "Redis master DOWN"

        # Select preferred master from slaves
        master = self.preferred_master(slaves)
        self.promote(master) unless @dryrun

        # Remove new master from slaves list
        slaves.delete(master)
      end

      # Too many running masters
      if masters.size > 1
        @log.warn "More than one master found"

        # Select preferred master from all masters
        master = self.preferred_master(masters)
        self.promote(master) unless @dryrun

        # Handle the rest of the masters as slaves
        slaves.concat(masters.reject { |m| m == master } )
      end

      # Alles klar, check that CNAME points to current master
      master = masters.first if masters.size == 1

      # Make sure DNS is up to date
      if self.cname_pointed?(cname, master)
        @log.info "CNAME #{@cname} points to current master '#{cname}'"
      else
        @log.warn "CNAME #{@cname} does not point to current master, expected '#{master[:host]}.' but got '#{cname}'"
        self.update_cname("#{master[:host]}.") unless @dryrun
      end

      # Finally make sure slave configuration is up to date
      self.update_slaves(slaves, master) unless @dryrun
    end

    def clean_and_exit(message)
      @log.warn "#{message}"
      exit 0
    end

    protected

    def members
      masters = Array.new 
      slaves = Array.new

      # Set defaults and generate some additional variables for easier DNS operations
      @redises.each do |redis|
        redis[:port] ||= 6379
        redis[:name] = redis[:host].split('.')[0]
        redis[:domain] = redis[:host].split('.')[-2..-1].join('.')
      end

      @redises.each do |server|
        begin
          redis = RedisShepherd::Info.new(server[:host], server[:port], server[:password])
          if redis.master?
            @log.info "MEMBER #{server[:name]} (#{server[:host]}) is MASTER"
            masters << server
          elsif redis.slave?
            @log.info "MEMBER #{server[:name]} (#{server[:host]}) is SLAVEOF #{redis.slaveof[:host]} #{redis.slaveof[:port]}"
            server[:slaveof] = redis.slaveof
            slaves << server
          end
        rescue Errno::ECONNREFUSED, Redis::TimeoutError, SocketError, Redis::CannotConnectError, Errno::ETIMEDOUT
          @log.warn "MEMBER #{server[:host]} is DOWN"
        end
      end
      return masters, slaves
    end

    def promote(master)
      @log.info "Promoting #{master[:host]} to master"
      connection(master[:host], master[:port], master[:password]) { |redis| redis.slaveof('NO', 'ONE') }
    end

    def demote(slave, master)
      @log.info "Demoting #{slave[:host]} to slaveof #{master[:host]} #{master[:port]}"
      connection(slave[:host], slave[:port], slave[:password]) { |redis| redis.slaveof(master[:host], master[:port]) }
    end

    def connection(host, port, password)
      begin
        redis = Redis.new(:host => host, :port => port, :password => password)
        yield(redis)
      rescue Errno::ECONNREFUSED
        @log.warn "Could not connect to #{server[:host]}: #{$!}"
      end
    end

    def cname
      cname = @dns.resolve(@cname)['data']
    end

    def cname_pointed?(cname, host)
      # CNAME can point to 'host' or 'host.domain.com.', check both
      names = ["#{host[:name]}", "#{host[:host]}."]
      names.each do |name|
        return true if name == cname
      end
      return false
    end

    def update_cname(data)
      @log.warn "Updating CNAME '#{@cname}' with '#{data}'"
      @dns.update(@cname, data)
    end

    def update_slaves(slaves, master)
      slaves.each do |slave|
        if slave[:slaveof]
          if slave[:slaveof][:host] == master[:host] and slave[:slaveof][:port].to_i == master[:port].to_i
             @log.info "Replication configuration of #{slave[:name]} is up-to-date"
            next
          end
        end
        @log.warn "Updating replication configuration for #{slave[:name]}"
        self.demote(slave, master)
      end
    end

    def preferred_master(servers)
      # See if the CNAME points to a server
      servers.each do |server|
        if self.cname_pointed?(cname, server)
          @log.warn "CNAME points to #{server[:name]} (#{server[:host]}:#{server[:port]}), promoting it to become a new master"
          return server
          break
        end
      end
      # If CNAME does not match, return first running server
      server = servers.first
      @log.warn "CNAME does not point any of the running servers, promoting #{server[:name]} (#{server[:host]}:#{server[:port]}) to become a new master"
      return server
    end

  end

end
