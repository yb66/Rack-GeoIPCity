# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/geoipcity/version"

Gem::Specification.new do |s|
  s.name        = "rack-geoipcity"
  s.version     = Rack::GeoIPCity::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karol Hosiawa", "Thomas Maurer", "Iain Barnett"]
  s.email       = ["iainspeed@gmail.com"]
  s.homepage    = "https://github.com/yb66/Rack-GeoIPCity"
  s.summary     = %q{Rack middleware for Geo IP city lookup}
  s.description = %q{Rack::GeoIPCity uses the geoip gem and the GeoIP database to lookup the city of a request by its IP address}
  s.license     = 'MIT'

  s.add_dependency 'rack'
  s.add_dependency 'geoip'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'wirble'
  s.add_development_dependency 'simplecov'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
