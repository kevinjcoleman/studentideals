require 'rails_helper'

RSpec.describe Region, type: :model do
  
  describe "geocoding stuff" do
    it "geocodes" do
      ungeocoded_business = create(:region)
      expect(ungeocoded_business.latitude).to eq (34.0729489)
      expect(ungeocoded_business.longitude).to eq (-118.4431764)
    end

    context "#lat_lng" do
      it "returns comma seperated lat_lng" do
        geocoded_business = create(:region)
        expect(geocoded_business.lat_lng).to eq ("34.0729489, -118.4431764")
      end
    end

    context "#full_address" do
      it "returns a string of full address" do
        geocoded_business = create(:region)
        expect(geocoded_business.full_address).to eq ("405 Hilgard Avenue, Los Angeles, CA, 90095, US")
      end
    end
  end
end
