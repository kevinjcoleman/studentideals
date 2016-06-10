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
end
