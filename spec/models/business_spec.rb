require 'active_support/core_ext/kernel/reporting'
require 'rails_helper'

RSpec.describe Business, type: :model do
  it { should belong_to(:region) }

  it { should have_many(:deals) }
  it { should have_many(:hours) }

  describe ".create" do
    context "with good info" do
      let(:business) { create(:business) }
      it { expect(business).to_not be_nil }
    end

    context "with address info" do
      let(:biz_with_address) { create(:business,:with_ungeocoded_address) }
        it "creates with lat/lng" do
          expect(biz_with_address.latitude).to eq (34.125297)
          expect(biz_with_address.longitude).to eq (-118.2166763)
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

  describe "before_import_save" do
    let!(:business) {Business.new }
    let!(:category) {create(:sid_category)}
    let(:record) {{sid_category_data: category.sid_category_id}}

    it "should add category on import" do
      business.before_import_save(record)
      expect(business.sid_category).to eq(category)
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

  describe "#custom_biz_label" do
    let(:business) { create(:business) }

    it "returns name" do
      expect(business.custom_biz_label).to eq(business.biz_name)
    end
  end

  context "tests needing region" do
    let!(:business) { create(:business,:with_lat_lng, :with_ungeocoded_address) }

    describe "#add_region" do
      context "with geocoded region" do
        let!(:geocoded_region) {create(:region, :with_lat_lng, :occidental)}
        before {business.add_region}

        it "returns region" do
          expect(business.region).to eq(geocoded_region)
        end
      end
      context "with ungeocoded region" do
        let!(:ungeocoded_region) {create(:region)}
        before {business.add_region}

        it "returns region" do
          expect(business.region).to eq(ungeocoded_region)
        end
      end

      context "with ungeocoded region, with a nil state" do
        let!(:ungeocoded_region) {create(:region)}
        before {business.add_region}

        it "returns region" do
          expect(business.region).to eq(ungeocoded_region)
        end
      end
    end

    describe "#link" do
      let!(:geocoded_region) {create(:region, :with_lat_lng, :occidental)}
      it "returns business link" do
        expect(business.link).to eq("/businesses/testy-mctesterson-s-tools")
      end
    end

    describe ".geojsonify" do
      let!(:geocoded_region) {create(:region, :with_lat_lng, :occidental)}
      it "returns geojson" do
        geojson = business.geojsonify(color: "blue")
        expect(geojson).to eq({:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-118.2166504, 34.1253012]}, :properties=>{:url=>"/businesses/testy-mctesterson-s-tools", :name=>"Testy Mctesterson's Tools", :address=>"1600 Alumni Avenue, Apt 8-201, Los Angeles, CA, 90041, US", :icon=>{:iconUrl=>"https://s3-us-west-1.amazonaws.com/studentidealswebapp/uploads/images/location.png", :iconSize=>[50, 50], :iconAnchor=>[25, 25], :popupAnchor=>[0, -25], :className=>"current-location"}}})
      end
    end
  end

  describe "regular scopes" do
    context ".without_sid_category" do
      let!(:business) { create(:business, :with_category)}
      let!(:business_without_category) { create(:business, biz_name: "Kevin's surfboards.")}

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

    context ".group_by_city" do
      before do
        3.times  {create(:business, :with_lat_lng, :with_ungeocoded_address)}
        2.times  {create(:business, :with_lat_lng, address1: "Address 1", city: "Huntington Beach", state: "CA")}
        @grouped_business = Business.group_by_city
        @first_group = @grouped_business.first
        @last_group = @grouped_business.last
      end

      it "orders by count" do
        expect(@first_group.city).to eq("Los Angeles")
        expect(@last_group.city).to eq("Huntington Beach")
      end

      it "returns accurate count" do
        expect(@first_group.count).to eq(3)
        expect(@last_group.count).to eq(2)
      end
    end

    context ".with_specific_sub_category" do
      let(:sub_category) {create(:sub_category)}
      let!(:business_with_sub_category) do
        business = create(:business)
        business.add_sub_category(sub_category)
        business.reload
      end
      let!(:business_without_sub_category) {create(:business)}

      it "returns only the associated business" do
        expect(Business.with_specific_sub_category(sub_category)).to eq([business_with_sub_category])
      end
    end
  end

  describe "geocoding scopes" do
    let!(:geocoded_business) { create(:business, :with_lat_lng, :with_ungeocoded_address)}
    let!(:ungeocoded_business) { create(:business, biz_name: "Kevin's surfboards.")}
    let!(:zero_lat_long_business) { create(:business, latitude: 0.0, longitude: 0.0, biz_name: "Mos Eisley Cantina")}
    let!(:region) {create(:region, :occidental)}

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

    context ".nearby" do
      it "returns only close addresses" do
        expect(Business.nearby(region)).to eq([geocoded_business])
      end
    end
  end

  describe "geocoding methods" do
    let(:biz_with_address_geocoded) { create(:business, :with_ungeocoded_address,:with_lat_lng) }
    let(:biz_with_no_address) {create(:business, biz_name: "Kevin's surfboards.")}

    context "#lat_lng" do
      it "returns comma seperated lat_lng" do
        expect(biz_with_address_geocoded.lat_lng).to eq ("34.1253012, -118.2166504")
      end

      it "returns nil when no address" do
        expect(biz_with_no_address.lat_lng).to be_nil
      end
    end

    context "#lat_lng_to_a" do
      it "returns lat/lng if existing" do
        expect(biz_with_address_geocoded.lat_lng_to_a).to eq([34.1253012, -118.2166504])
      end

      it "returns nil if no lat/lng" do
        expect(biz_with_no_address.lat_lng_to_a).to be nil
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

  describe "#add_sub_category" do
    let(:sub_category) { create(:sub_category) }
    let(:business) { create(:business) }

    it "adds a sub_category" do
      business.add_sub_category(sub_category)
      expect(business.sub_categories).to eq([sub_category])
    end

    it "doesn't add duplicate sub_category_taggings" do
      business.add_sub_category(sub_category)
      business.add_sub_category(sub_category)
      expect(business.sub_category_taggings.count).to eq(1)
    end
  end

  describe "#add_factual_categories" do
    let(:business) { create(:business, :with_category) }
    it "adds new sub categories from factual" do
      business.add_factual_categories
      expect(business.sub_categories.map(&:label)).to eq(["Restaurants", "American", "Barbecue", "Italian"])
    end

    it "doesn't duplicate existing sub categories or taggings." do
      business.add_factual_categories
      business.add_factual_categories
      expect(business.sub_categories.count).to eq 4
      expect(business.sub_category_taggings.count).to eq 4
    end

    it "doesn't fail on a non-existant id" do
      expect(STDOUT).to receive(:puts).with("There is no entity associated with the factual_id 34056115-0a65-46d4-9e57-1f65a6ed8140")
      business.update_attributes(external_id: "34056115-0a65-46d4-9e57-1f65a6ed8140")
      business.add_factual_categories
    end
  end

  describe ".batch_add_factual_categories" do
    let!(:business) { create(:business, :with_category) }
    it "adds new sub categories from factual" do
      Business.batch_add_factual_categories
      expect(business.reload.sub_categories.map(&:label)).to eq(["Restaurants", "American", "Barbecue", "Italian"])
    end
  end

  describe "deal info" do
    let!(:business) { create(:business, biz_id: 1) }
    let!(:deal) { create(:deal) }
    it ".deal returns the first deal" do
      expect(business.deal).to eq deal
    end
  end

  describe ".website_description" do
    let(:business_with_link_in_bio) { create(:business, sid_editorial: "http://www.yelp.com/biz/i-love-thai-arlington Eco-friendly residential and commercial cleaning service; uses HEPA vacuum filters and homemade, non-toxic cleaning products.") }
    let(:business_without_link_in_bio) { create(:business, sid_editorial: "Eco-friendly residential and commercial cleaning service; uses HEPA vacuum filters and homemade, non-toxic cleaning products.") }
    context "with a link" do
      it "adds <a>" do
        expect(business_with_link_in_bio.website_description).to eq "<a href=\"http://www.yelp.com/biz/i-love-thai-arlington\" target=\"_blank\">http://www.yelp.com/biz/i-love-thai-arlington</a> Eco-friendly residential and commercial cleaning service; uses HEPA vacuum filters and homemade, non-toxic cleaning products."
      end
    end

    context "without a link" do
      it "returns same sid_editorial" do
        expect(business_without_link_in_bio.website_description).to eq business_without_link_in_bio.sid_editorial
      end
    end
  end

  describe "hour related methods" do
    let(:business) { create(:business, :with_ungeocoded_address,:with_lat_lng) }
    describe "#has_day?" do
      context "with existing hour" do
        let!(:hour) {create(:biz_hour, business: business)}
        it "is true" do
          expect(business.has_day?(0)).to be_truthy
        end
      end

      context "without existing hour" do
        it "is false" do
          expect(business.has_day?(0)).to be_falsey
        end
      end
    end

    describe "#timezone" do
      context "Eastern state" do
        let(:eastern_state) { create(:business, :with_ungeocoded_address,:with_lat_lng, state: "MD") }
        it "is est" do
          expect(eastern_state.timezone).to eq("est")
        end
      end

      context "western state" do
        it "is pst" do
          expect(business.timezone).to eq("pst")
        end
      end
    end
  end
end
