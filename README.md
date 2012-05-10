# redis-shepherd
Redis-shepherd monitors and tries to maintain master/slave replication configuration up to date. It also keeps the specified CNAME record pointed to a running master.

## Installation
### Setup DNS Made Easy API Key & Secret Key to ~/.fog

    :default:
      :dnsmadeeasy_api_key: acb123-def456
      :dnsmadeeasy_secret_key: def456-acb123

### Define configuration in _config/shepherd.yml_
See config/shepherd.yml.example for details

### Turn off dry-run mode in _redis-shepherd.rb_

    cluster.dryrun = false

### Run it
You probably want to run the script via cron or use daemonization
