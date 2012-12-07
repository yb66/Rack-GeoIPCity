# encoding: UTF-8

require 'rubygems'
require 'bundler'
Bundler.require


require 'rack/geoipcity'
require 'haml'

root = File.expand_path File.dirname(__FILE__)

# everything was moved into a separate module/file to make it easier to set up tests

class FakeIps
  def ip
    @ips.sample
  end
  
  def initialize
    @ips = ["87.237.57.28","89.145.84.82","119.63.193.39","122.152.129.9","193.26.222.136","202.165.96.142","209.198.242.61","212.209.54.40","216.239.41.97"]
  end
end

use Rack::GeoIPCity, :db => File.join(root, "assets/GeoLiteCity.dat"), :ips => FakeIps.new#, :path => %r{^/geo}#, :prefix => "/ge"


layout = ->(){ 
  File.read File.join(root, "views/layout.haml" )
}

app = lambda do |env|
  request = Rack::Request.new(env)
  stuff_here = env.select{|x| x =~ /^GEOIP/ }.inspect
  output = Haml::Engine.new(layout.call).render( Object.new,
    :stuff_here =>  stuff_here
  )
  Rack::Response.new( output ).finish
end

run app
