module RedisShepherd
  
  class DNS

    def initialize(config)
      @dns = Fog::DNS.new(config)
    end

    def update(hostname, data, type='CNAME', ttl=60)
      name, domain = self.split_hostname(hostname)
      record = self.resolve(hostname)
      if record
        record_id = record['id']
        ttl = record['ttl']  # Keep old ttl value if it has been altered manually
        @dns.update_record(domain, record_id, options = { 'name' => name, 'type' => type, 'ttl' => ttl, 'data' => data })
      else
        @dns.create_record(domain, name, type, data, options = { 'ttl' => ttl })
      end
    end

    def resolve(hostname)
      name, domain = self.split_hostname(hostname)
      records =  @dns.list_records(domain).body      
      record = records.select { |record| record['name'] == name }
      record.first
    end
  
    protected 
    
    def split_hostname(hostname)
      name = hostname.split('.')[0]
      domain =  hostname.split('.')[-2..-1].join('.')
      return name, domain 
    end
  end

end