require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:region) {create(:region, name: "test region")}
  let!(:sid_category) {create(:sid_category, label: "test sid_category")}
  let!(:sub_category) {create(:sub_category, label: "test sub_category", sid_category: sid_category)}
  let!(:business) {create(:business, :with_ungeocoded_address, :with_lat_lng, biz_name: "test business")}

  describe "GET #results" do
    context "it's successful with random query" do 
      before { get :results, query: "random query" }
      it { should respond_with(:success) }
    end

    context "json rendering" do 
    before do 
      get :results, query: "test" 
    end

    let!(:results) {JSON.parse(response.body)["results"]}
      it "returns the business json correctly" do 
        business_json = find_searchable_type(results, "Business")
        expect(business_json["label"]).to eq(business.biz_name)
        expect(business_json["id"]).to eq(business.slug)
        expect(business_json["url"]).to eq("/region/#{business.region.slug}/businesses/#{business.slug}")
      end

      it "returns the sid_category json correctly" do 
        sid_category_json = find_searchable_type(results, "SID Category")
        expect(sid_category_json["label"]).to eq(sid_category.label)
        expect(sid_category_json["id"]).to eq(sid_category.slug)
        expect(sid_category_json["url"]).to eq("/category/#{sid_category.slug}")
      end

      it "returns the sub_category json correctly" do 
        sub_category_json = find_searchable_type(results, "Category")
        expect(sub_category_json["label"]).to eq(sub_category.label)
        expect(sub_category_json["id"]).to eq(sub_category.slug)
        expect(sub_category_json["url"]).to eq("/category/#{sub_category.sid_category.slug}/sub_category/#{sub_category.slug}")
      end

      it "returns the region json correctly" do 
        region_json = find_searchable_type(results, "Locale")
        expect(region_json["label"]).to eq(region.name)
        expect(region_json["id"]).to eq(region.slug)
        expect(region_json["url"]).to eq("/region/#{region.slug}")
      end
    end

    context "ordering" do 
      before do 
        get :results, query: "test" 
      end

      let!(:results) {JSON.parse(response.body)["results"]}

      it "returns Locale first" do 
        expect(results.first["searchable_type"]).to eq "Locale"
      end

      it "returns sid_category second" do 
        expect(results[1]["searchable_type"]).to eq "SID Category"
      end

      it "returns sub_category third" do 
        expect(results[2]["searchable_type"]).to eq "Category"
      end

      it "returns business last" do 
        expect(results.last["searchable_type"]).to eq "Business"
      end
    end


    
    def find_searchable_type(results, searchable_type)
      results.find {|r| r["searchable_type"].to_s ==  searchable_type }
    end
  end
end
