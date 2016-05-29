class GeocoderTestController < ApplicationController
  def test
    @location = request.location
  end
end
