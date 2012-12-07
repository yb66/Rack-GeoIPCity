require 'rack/fake_ip'
require_relative "../../../lib/rack/geoipcity.rb"


module App

  def self.app( options={} )
    Rack::Builder.app do
      ip_opts = {}
      ip_opts.merge!( {ip: options[:ip] } ) if options[:ip]
      use Rack::FakeIP, ip_opts
      use Rack::GeoIPCity, :db => File.expand_path( File.join(File.dirname(__FILE__), "../assets/GeoLiteCity.dat"))

      geo_info = ->(env) {
        h = {}
        env.select{|x| x =~ /^GEOIP/ }.each {|k,v|
          h[k.split("GEOIP_").last.downcase] = v
        }
        h
      }

      routes = lambda { |e|
        request = Rack::Request.new(e)
        response = if request.path == "/"
          Rack::Response.new(
            [Marshal.dump(geo_info.(e))],
            200,
            {"Content-Type" => "text/html"}
          ).finish
        elsif request.path.start_with? "/ip/"
          ip_in_route = request.path.split("/ip/").last
          ip = Rack::GeoIPCity.db.city ip_in_route
          Rack::Response.new(
            [Marshal.dump(Hash[ip.each_pair.to_a])],
            200,
            {"Content-Type" => "text/html"}
          ).finish
        end
        response
      }
      run routes
    end
  end    
end


shared_context "All routes" do |options={}|
  include Rack::Test::Methods
  warn "options = #{options.inspect}"
  let(:app){ App.app( options ) }
end

shared_examples_for "Any route" do
  subject {
    last_response
  }
  it { should be_ok }
end