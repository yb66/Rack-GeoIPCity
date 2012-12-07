
require 'spec_helper'


describe "A normal route" do
  # set a known static ip to help with testing
  # i.e. Wikipedia
  include_context "All routes", :ip => "208.80.152.201"
  before do
    get "/"
  end
  it_should_behave_like "Any route"
  subject { Marshal.load last_response.body }
  it { should respond_to :keys }
  its(:keys) { should include "country_code2", "country_code3", "country_name", "continent_code", "region_name", "city_name", "postal_code", "latitude", "longitude", "timezone", "ip" }
  its(:values) { should include "US", "USA", "United States", "NA", "CA", "San Francisco", "94105", 37.789800000000014, -122.3942, 807, 415, "America/Los_Angeles", "208.80.152.201" }
end

describe "Using the database from inside another app." do
  include_context "All routes"
  subject { Rack::GeoIPCity.db }
  it { should_not be_nil }
  it { should respond_to :city }

  context "Given an IP" do
    subject { Rack::GeoIPCity.db.city "208.80.152.201" }
    it { should respond_to :members }
    its(:members) { should include :country_code2, :country_code3, :country_name, :continent_code, :region_name, :city_name, :postal_code, :latitude, :longitude, :timezone, :ip }
    its(:values) { should include "US", "USA", "United States", "NA", "CA", "San Francisco", "94105", 37.789800000000014, -122.3942, 807, 415, "America/Los_Angeles", "208.80.152.201" }
  end

  context "Called from inside a route" do
    before do
      get "/ip/208.80.152.201"
    end
    subject { Marshal.load last_response.body }
    it { should respond_to :keys }
    its(:keys) { should include :country_code2, :country_code3, :country_name, :continent_code, :region_name, :city_name, :postal_code, :latitude, :longitude, :timezone, :ip }
    its(:values) { should include "US", "USA", "United States", "NA", "CA", "San Francisco", "94105", 37.789800000000014, -122.3942, 807, 415, "America/Los_Angeles", "208.80.152.201" }
  end
end