require 'rails_helper'

RSpec.describe Business, type: :model do
  describe ".create" do
    context "with good info" do
      it "creates with valid attributes" do
        business = create(:business)
        expect(business).to_not be_nil
      end
    end

    context "bad info" do
      it "is invalid w/o name" do
        business = build(:business, biz_name: nil)
        expect(business).to_not be_valid
      end

      it "is invalid with short name" do
        business = build(:business, biz_name: "KC")
        expect(business).to_not be_valid
      end
    end
  end

  describe "add SID category through sid_category_id" do
    before { @business = create(:business)}
    before { @category = create(:sid_category)}
    it "creates an associate with an existing sid_category_id" do
      @business.add_sid_category("3")
      @business.save
      expect(@business.sid_category).to eq @category
    end
  end

  describe "scopes" do
    context "without_sid_category" do
      before do
        create(:sid_category) 
        @business = create(:business)
        @business_without_category = create(:business)
        @business.add_sid_category("3")
        @business.save
      end

      it "returns businesses without categories" do
        without_categories = Business.without_sid_category
        expect(without_categories.find(@business_without_category.id)).to_not be_nil
      end

      it "doesn't return businesses with categories" do
        without_categories = Business.without_sid_category
        expect(without_categories.where(id: @business.id).first).to be_nil
      end
    end

    context "geocoded" do
      it "returns just geocoded businesses" do
        geocoded_business = create(:business,:with_ungeocoded_address, :with_lat_lng)
        expect(Business.geocoded).to eq([geocoded_business])
      end

      it "doesn't return ungeocoded businesses" do
        ungeocoded_business = create(:business)
        expect(Business.geocoded).to_not eq([ungeocoded_business])
      end

      it "doesn't return businesses with lat and long of 0.0" do
        lat_long_of_zero = create(:business, latitude: 0.0, longitude: 0.0)
        expect(Business.geocoded).to_not eq([lat_long_of_zero])       
      end
    end

    context "ungeocoded" do
      it "returns ungeocoded businesses" do
        geocoded_business = create(:business)
        expect(Business.ungeocoded).to eq([geocoded_business])
      end

      it "doesn't return geocoded businesses" do
        geocoded_business = create(:business,:with_ungeocoded_address, :with_lat_lng)
        expect(Business.ungeocoded).to_not eq([geocoded_business])
      end

      it "doesn't returns businesses with lat and long of 0.0" do
        lat_long_of_zero = create(:business, latitude: 0.0, longitude: 0.0)
        expect(Business.ungeocoded).to eq([lat_long_of_zero]) 
      end
    end
  end

  describe "geocoding stuff" do
    it "geocodes" do
      ungeocoded_business = create(:business,:with_ungeocoded_address)
      expect(ungeocoded_business.latitude).to eq (34.1253012)
      expect(ungeocoded_business.longitude).to eq (-118.2166504)
    end

    context "#lat_lng" do
      it "returns comma seperated lat_lng" do
        geocoded_business = create(:business,:with_ungeocoded_address, :with_lat_lng)
        expect(geocoded_business.lat_lng).to eq ("34.1253012, -118.2166504")
      end
    end

    context "#full_address" do
      it "returns a string of full address" do
        geocoded_business = create(:business,:with_ungeocoded_address, :with_lat_lng)
        expect(geocoded_business.full_address).to eq ("1600 Alumni Avenue, Apt 8-201, Los Angeles, CA, 90041, US")
      end
    end

    context "address info for display" do
      before { @business = create(:business,:with_ungeocoded_address, :with_lat_lng)}
      it "#address_line_1 returns the first line of the address" do
        expect(@business.address_line_1).to eq("1600 Alumni Avenue, Apt 8-201")
      end

      it "#address_line_2 returns the second line of the address" do
        expect(@business.address_line_2).to eq("Los Angeles, CA, 90041, US")
      end
    end
  end
end
