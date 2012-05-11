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

## License
(The MIT License)

Copyright(c) 2012 Applifier Ltd.<br />

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
