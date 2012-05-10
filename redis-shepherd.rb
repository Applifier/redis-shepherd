#!/usr/bin/env ruby

require 'rubygems'
require 'lib/redis-cluster.rb'

# Check if we're called from cmdline or required from another script
if __FILE__ == $0
  cname = 'ha-redis.applifier.info'
  redises = [{:host => 'ha-redis1.applifier.info', :port => 6379}, {:host => 'ha-redis2.applifier.info', :port => 6380}]

  cluster = RedisCluster.new(cname, redises)
  cluster.dryrun = true
  cluster.shepherd
end

