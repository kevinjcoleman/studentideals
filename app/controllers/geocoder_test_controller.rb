class GeocoderTestController < ApplicationController
  def geolocation_api
    if cookies[:lat_lng]
      @lat_lng = cookies[:lat_lng].split("|")
    end
  end

  def test
    @location = request.location
  end
end
