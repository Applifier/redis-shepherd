$:.unshift File.dirname(__FILE__)

# stdlib
require 'yaml'
require 'optparse'

# 3rd party
require 'redis'
require 'fog'
require 'logger'

# internal requires
require 'redis-shepherd/cluster'
require 'redis-shepherd/info'
require 'redis-shepherd/dns'
