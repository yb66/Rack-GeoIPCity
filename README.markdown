Rack::GeoIPCity uses the geoip gem and the GeoIP database to lookup the geographical info of a request by its IP address.  
The database can be downloaded from:

(Lite version) http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz, instructions are here http://www.maxmind.com/app/geolitecity.

http://www.maxmind.com/app/city for full version.

*NOTE!* If you're using the country database you'll get a different struct returned, so use the GeoIPCountry gem, rack-geoipcountry. I'd make this middleware do both but:

a) It would be slower   
b) there's already a country gem and   
c) you can do the branching yourself if you really want, but why would you?  

## Usage:

use Rack::GeoIPCity, :db => "path/to/GeoIP.dat"

By default all requests are looked up and the X_GEOIP_* headers are added to the request. The headers can then be read in the application.  
The country name is added to the request header as X_GEOIP_COUNTRY, eg:  
X_GEOIP_COUNTRY: United Kingdom

The full set of GEOIP request headers is below:  
X_GEOIP_COUNTRY_CODE - The ISO3166-1 two-character country code, if not found set to --  
X_GEOIP_COUNTRY_CODE3 - The ISO3166-2 three-character country code, if not found set to --  
X_GEOIP_COUNTRY - The ISO3166 English-language name of the country, if not found set to an empty string  
X_GEOIP_CONTINENT if not found set to an empty string  
X_GEOIP_REGION_NAME if not found set to an empty string  
X_GEOIP_CITY_NAME if not found set to an empty string  
X_GEOIP_POSTAL_CODE if not found set to an empty string  
X_GEOIP_LATITUDE if not found won't be returned as I can't think of another good return value to signify "not found"  
X_GEOIP_LONGITUDE if not found won't be returned as I can't think of another good return value to signify "not found"  
'X_GEOIP_DMA_CODE' The metropolitan code (this is for the USA, see http://code.google.com/apis/adwords/docs/appendix/metrocodes.html if you're interested), default 0 for not found.  
X_GEOIP_AREA_CODE if not found set to an empty string  
X_GEOIP_TIMEZONE if not found set to an empty string  
X_GEOIP_CONTINENT - The two-character continent code, if not found set to an empty string  


You can use the included Mapping class to trigger lookup only for certain requests by specifying matching path prefix in options, eg:  
use Rack::GeoIPCity::Mapping, :prefix => '/video_tracking'  
The above will lookup IP addresses only for requests matching /video_tracking etc.

MIT License -   
Originally by Karol Hosiawa ( http://twitter.com/hosiawak )  
Converted to a gem by Thomas Maurer  
This one by Iain Barnett  