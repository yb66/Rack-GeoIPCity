require 'geoip'

module Rack
  
  # See the README for more docs
  class GeoIPCity
    def initialize(app, options = {})
      options[:db] ||= 'GeoIP.dat'
      @db = GeoIP.new(options[:db])
      @app = app
    end
    
    DEFAULTS = {
      'X_GEOIP_COUNTRY_CODE' => 0,
      'X_GEOIP_COUNTRY_CODE3' => 0,
      'X_GEOIP_COUNTRY' => '',
      'X_GEOIP_CONTINENT' => '',
      'X_GEOIP_REGION_NAME' => '',
      'X_GEOIP_CITY_NAME' => '',
      'X_GEOIP_POSTAL_CODE' => '' ,
      'X_GEOIP_LATITUDE' => nil,
      'X_GEOIP_LONGITUDE' => nil,
      'X_GEOIP_DMA_CODE' => 0,
      'X_GEOIP_AREA_CODE' => 0,
      'X_GEOIP_TIMEZONE' => '',
    }

    def call(env)
      res = @db.city(env['REMOTE_ADDR'])
      
      unless res.nil? # won't bork on local or bad ip's
        hash = {}
        hash['X_GEOIP_COUNTRY_CODE'] = res.country_code2 unless res.country_code2.nil?
        hash['X_GEOIP_COUNTRY_CODE3'] = res.country_code3 unless res.country_code3.nil?
        hash['X_GEOIP_COUNTRY'] = res.country_name unless res.country_name.nil?
        hash['X_GEOIP_CONTINENT'] = res.continent_code unless res.continent_code.nil?
        hash['X_GEOIP_REGION_NAME'] = res.region_name unless res.region_name.nil?
        hash['X_GEOIP_CITY_NAME'] = res.city_name unless res.city_name.nil?
        hash['X_GEOIP_POSTAL_CODE'] = res.postal_code unless res.postal_code.nil?
        hash['X_GEOIP_LATITUDE'] = res.latitude 
        hash['X_GEOIP_LONGITUDE'] = res.longitude
        hash['X_GEOIP_DMA_CODE'] = res.dma_code unless res.dma_code.nil?
        hash['X_GEOIP_AREA_CODE'] = res.area_code unless res.area_code.nil?
        hash['X_GEOIP_TIMEZONE'] = res.timezone unless res.timezone.nil?
        
        hash.delete_if{|k,v| v.nil? } # remove latitude and longitude and any other stragglers
        env.merge!( DEFAULTS.merge hash )
      end 
      
      @app.call(env)
    end

    class Mapping
      def initialize(app, options = {})
        @app, @prefix = app, /^#{options.delete(:prefix)}/
        @geoip = GeoIPCity.new(app, options)
      end

      def call(env)
        if env['PATH_INFO'] =~ @prefix
          @geoip.call(env)
        else
          @app.call(env)
        end
      end
    end
    
  end
end
