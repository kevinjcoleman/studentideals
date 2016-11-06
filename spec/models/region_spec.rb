require 'rails_helper'

RSpec.describe Region, type: :model do
  describe ".create" do
    let!(:region) { create(:region) }

    it "geocodes" do
      expect(region.latitude).to eq (34.0729489)
      expect(region.longitude).to eq (-118.4431764)
    end

    it "doesn't allow duplicates" do
      expect { create(:region) }.to raise_error ActiveRecord::RecordInvalid
    end

    context "#lat_lng" do
      it { expect(region.lat_lng).to eq ("34.0729489, -118.4431764") }
    end

    context "#full_address" do
      it { expect(region.full_address).to eq ("405 Hilgard Avenue, Los Angeles, CA, 90095, US") }
    end
  end

  describe ".geojsonify" do 
    let!(:region) {create(:region)}
    it "returns geojson" do 
      geojson = region.geojsonify(color: "blue")
      expect(geojson).to eq({:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-118.4431764, 34.0729489]}, :properties=>{:name=>"UCLA", :"marker-color"=>"#229AD6", :"marker-size"=>"medium"}})
    end
  end

  describe ".cache_biz_count" do 
    let(:region) {create(:region, :occidental)}
    let!(:business) { create(:business, :with_lat_lng, :with_ungeocoded_address) }
    let(:other_region) {create(:region, city: "Washington", state: "DC")}

    context "with a close address" do
      it "updates close_biz_count" do 
        region.cache_biz_count 
        expect(region.reload.close_biz_count).to eq(1)
      end
    end


    context "without a close address" do 
      it "close_biz_count stays at zero" do
        other_region.cache_biz_count 
        expect(other_region.reload.close_biz_count).to eq(0)
      end
    end  
  end
end
