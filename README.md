# redis-shepherd
Redis-shepherd monitors and tries to maintain master/slave replication configuration up to date. It also keeps the specified CNAME record pointed to a running master.

## Installation
### Setup DNS Made Easy API Key & Secret Key to ~/.fog

    :default:
      :dnsmadeeasy_api_key: acb123-def456
      :dnsmadeeasy_secret_key: def456-acb123

### Define redis servers in _redis-shepherd.rb_

    cname = 'ha-redis.example.net'
    redises = [{:host => 'redis1.example.net', :port => 6379}, {:host => 'redis2.example.net', :port => 6380}]

### Turn off dry-run mode in _redis-shepherd.rb_

    cluster.dryrun = false

### Run it
You probably want to run the script via cron or use daemonization
