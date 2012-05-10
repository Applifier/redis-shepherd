require 'fog'

class DNS

  def initialize()
    config = YAML::load(File.open(ENV['HOME']+'/.fog'))[:default]
    @dns = Fog::DNS::DNSMadeEasy.new(
      :dnsmadeeasy_api_key =>  config[:dnsmadeeasy_api_key],
      :dnsmadeeasy_secret_key => config[:dnsmadeeasy_secret_key]
    )
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
    records.each { |record| return record if record['name'] == name }
    return false
  end
  
  protected 
    
  def split_hostname(hostname)
    name = hostname.split('.')[0]
    domain =  hostname.split('.')[-2..-1].join('.')
    return name, domain 
  end
end