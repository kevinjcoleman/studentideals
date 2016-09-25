require 'rails_helper'

RSpec.describe Business, type: :model do
  it { should have_many(:deals) }
  describe ".create" do
    context "with good info" do
      let(:business) { create(:business) }
      it { expect(business).to_not be_nil }
    end

    context "with address info" do
      let(:biz_with_address) { create(:business,:with_ungeocoded_address) }
        it "creates with lat/lng" do
          expect(biz_with_address.latitude).to eq (34.1253012)
          expect(biz_with_address.longitude).to eq (-118.2166504)
        end
    end

    context "bad info" do
      let(:business) { build(:business, biz_name: nil) }
      it "is invalid w/o name" do
        expect(business).to_not be_valid
      end

      it "is invalid with a short name" do
        business.biz_name = "KC"
        expect(business).to_not be_valid
      end
    end
  end

  describe "#add_sid_category" do
    let(:business) { create(:business) }
    
    context "with existing category" do
      let(:category) { create(:sid_category) }
      
      it "creates an association" do
        business.add_sid_category(category.sid_category_id) && business.save!
        expect(business.sid_category).to eq category
      end
    end

    context "with non-existant category" do
      it "raises an error" do
        expect { business.add_sid_category("3") && business.save! }.to raise_error "Category doesn't exist!"
      end
    end
  end

  describe "#region" do 
    let(:business) { create(:business, :with_ungeocoded_address) }
    let!(:region) {create(:region, city: business.city, state: business.state)}
    it "returns the correct region" do 
      expect(business.region).to eq region
    end
  end

  describe "regular scopes" do
    context ".without_sid_category" do
      let(:business) { create(:business, :with_category)}
      let(:business_without_category) { create(:business, biz_name: "Kevin's surfboards.")}

      it "returns only businesses without categories" do
        expect(Business.without_sid_category).to eq([business_without_category])
      end
    end

    context ".with_factual" do
      let!(:without_factual) { create(:business, external_id: nil) }
      let!(:with_factual) { create(:business) }
      it "returns only the business with an external_id" do
        expect(Business.with_factual.count).to eq 1
        expect(Business.with_factual.first).to eq with_factual
      end
    end

    context ".no_sub_categories" do
      let!(:with_sub_categories) { create(:business, :with_category) }
      let!(:without_sub_categories) { create(:business) }
      it "returns only the business with out sub_categories" do
        with_sub_categories.add_factual_categories
        expect(Business.no_sub_categories.count.count).to eq 1
        expect(Business.no_sub_categories.first).to eq without_sub_categories
      end
    end
  end

  describe "geocoding scopes" do
    let!(:geocoded_business) { create(:business, :with_lat_lng, :with_ungeocoded_address)}
    let!(:ungeocoded_business) { create(:business, biz_name: "Kevin's surfboards.")}
    let!(:zero_lat_long_business) { create(:business, latitude: 0.0, longitude: 0.0, biz_name: "Mos Eisley Cantina")}
    
    context ".geocoded" do
      it "returns just geocoded businesses" do
        expect(Business.geocoded).to eq([geocoded_business])
      end
    end

    context ".ungeocoded" do
      it "returns ungeocoded businesses" do
        expect(Business.ungeocoded.first).to eq(ungeocoded_business)
      end

      it "returns businesses with lat and long of 0.0" do
        expect(Business.ungeocoded.last).to eq(zero_lat_long_business) 
      end
    end

    context ".lat_long_of_zero" do
      it "returns just businesses with lat and long of 0.0" do
        expect(Business.lat_long_of_zero).to eq([zero_lat_long_business]) 
      end
    end
  end

  describe "geocoding methods" do
    let(:biz_with_address_geocoded) { create(:business,:with_ungeocoded_address,:with_lat_lng) }
    let(:biz_with_no_address) {create(:business, biz_name: "Kevin's surfboards.")}

    context "#lat_lng" do
      it "returns comma seperated lat_lng" do
        expect(biz_with_address_geocoded.lat_lng).to eq ("34.1253012, -118.2166504")
      end

      it "returns nil when no address" do
        expect(biz_with_no_address.lat_lng).to be_nil
      end
    end

    context "#full_address" do
      it "returns a string of full address" do
        expect(biz_with_address_geocoded.full_address).to eq ("1600 Alumni Avenue, Apt 8-201, Los Angeles, CA, 90041, US")
      end

      it "returns nil when no address" do
        expect(biz_with_no_address.full_address).to be_nil
      end
    end

    context "address info for display" do
      it "returns address broken into two lines" do
        expect(biz_with_address_geocoded.address_line_1).to eq("1600 Alumni Avenue, Apt 8-201")
        expect(biz_with_address_geocoded.address_line_2).to eq("Los Angeles, CA, 90041, US")
      end

      it "returns nil when no address" do
        expect(biz_with_no_address.address_line_1).to be_nil
        expect(biz_with_no_address.address_line_2).to be_nil
      end
    end
  end

  describe "adding sub categories" do
    let(:business) { create(:business, :with_category) }
    it "adds new sub categories from factual" do 
      business.add_factual_categories
      expect(business.sub_categories.map(&:label)).to eq(["Restaurants", "American", "Fast Food", "Italian"])
    end

    it "doesn't duplicate existing sub categories or taggings." do
      business.add_factual_categories
      business.add_factual_categories
      expect(business.sub_categories.count).to eq 4
      expect(business.sub_category_taggings.count).to eq 4
    end

    it "doesn't fail on a non-existant id" do 
      business.update_attributes(external_id: "34056115-0a65-46d4-9e57-1f65a6ed8140")
      business.add_factual_categories
    end
  end
end
