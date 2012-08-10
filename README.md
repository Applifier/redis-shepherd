# redis-shepherd
Redis-shepherd monitors and tries to maintain master/slave replication configuration up to date. It also keeps the specified CNAME record pointed to a running master.

## Description
- Resolves where the master's CNAME points at the moment
- Creates a list of running servers (master(s) and slaves)
- If all servers down there's nothing to do but exit with an error
- If there's no running master
    - Select new preferred master from slaves
- If there's too many running masters
    - Select preferred master from all available masters
    - Handle the rest of the masters as slaves
- Make sure DNS CNAME is up to date (points to master)
- Finally make sure slave configuration is up to date

*Preferred master is a server where the CNAME currently points. If CNAME does not point to any running server, select first available server*

## Installation
Clone or fork the project

### Define configuration in _config/shepherd.yml_
See _config/shepherd.yml.example_ for details. At the moment only DNS Made Easy has been tested. 

### Run it
You can run the script via cron or use daemonization

Cron

	ruby -rubygems bin/redis-shepherd

Daemonization

	ruby -rubygems /bin/redis-shepherdctl start
	ruby -rubygems /bin/redis-shepherdctl stop

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
