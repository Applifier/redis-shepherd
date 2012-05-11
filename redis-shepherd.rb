#!/usr/bin/env ruby

require 'rubygems'
require 'lib/redis-cluster.rb'

# Check if we're called from cmdline or required from another script
if __FILE__ == $0

  begin
    require 'yaml'
    cfile = File.join(File.dirname(__FILE__), 'config/shepherd.yml')
    config = YAML::load(File.open(cfile))
  rescue
    raise "Could not read configuration file #{cfile}: #{$!}"
  end

  cluster = RedisCluster.new(config[:cname], config[:redises])
  cluster.dryrun = true

  cluster.shepherd
end

