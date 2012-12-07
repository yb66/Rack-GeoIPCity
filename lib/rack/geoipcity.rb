require 'geoip'

module Rack
  
  # See the README for more docs
  class GeoIPCity

    def self.db=( db )
      @db = db
    end

    def self.db
      @db
    end

    # @param [Hash] options
    # @option options [String] :db Path to the GeoIP database
    # @option options [#ip] :ips ('Rack::Request.new(env)') An object that responds to `ip` and gives an IP address. You'll probably want to use this when you're developing/testing locally and want to pass in fake addresses to get the GeoIP to fire something other than blanks.
    # @option options [Regexp] :path
    # @option options [String] :prefix
    def initialize(app, options = {})
      options[:db] ||= 'GeoIP.dat'
      @ips           = options[:ips]
      @path          = ->(env){ env['PATH_INFO'].start_with? options[:prefix] } unless options[:prefix].nil?
      @path          = ->(env){ env['PATH_INFO'] =~ options[:path] } unless options[:path].nil?
      @path         ||= ->(_){ true }
      self.class.db  = GeoIP.new(options[:db])
      @app           = app
    end
  
    def call(env)
      if @path.call(env)
        ips = @ips || Rack::Request.new(env)
        res = self.class.db.city ips.ip
        unless res.nil? # won't bork on local or bad ip's
          h = Hash[ [:country_code2, :country_code3, :country_name, :continent_code, :region_name, :city_name, :postal_code, :latitude, :longitude, :dma_code, :area_code, :timezone, :ip,].map{|x| [ "GEOIP_#{x.upcase}", res.__send__(x) ] } ].delete_if{|k,v| v.nil? }
          
          env.merge! h
        end 
      end      
      @app.call(env)
    end
    
  end # GeoIPCity
end # Rack
