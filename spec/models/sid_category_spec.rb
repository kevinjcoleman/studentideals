require 'rails_helper'

RSpec.describe SidCategory, type: :model do
  describe ".create" do
    let!(:sid_category) {create(:sid_category)}
    context "with valid info" do
      it { expect(sid_category).to_not be_nil }
    end

    context "with incomplete info" do
      it "is invalid on missing label" do
        expect(build(:sid_category,  sid_category_id: "12", label: nil)).to_not be_valid       
      end

      it "is invalid on missing sid category id" do
        expect(build(:sid_category, sid_category_id: nil, label: "Restaurants")).to_not be_valid       
      end

      it "fails to create duplicate category" do
        expect { create(:sid_category) }.to raise_error ActiveRecord::RecordInvalid
      end      
    end
  end
  
  context "#business_count" do
    let!(:category_with_businesses) {create(:sid_category, :category_with_businesses)}
    let!(:unassociated_business) {create(:business, biz_name: "Ollivanders wand shop.")}
    let!(:category_with_no_businesses) {create(:sid_category, label: "Surf wax", sid_category_id: "2")}

    it "returns an count of businesses for category." do
      expect(category_with_businesses.business_count).to eq(1)
    end

    it "returns 0 if no businesses." do
      expect(category_with_no_businesses.business_count).to eq(0)
    end
  end

  context "#custom_sid_label" do 
    let!(:category) {create(:sid_category, label: "Surf wax")}
    it "returns label" do 
      expect(category.custom_sid_label).to eq("Surf wax")
    end
  end

  context "scopes" do 
    let!(:category_with_businesses) {create(:sid_category, :category_with_businesses)}
    let!(:category_with_no_businesses) {create(:sid_category, label: "Surf wax", sid_category_id: "2")}
    describe ".left_outer_join_businesses" do 
      let!(:categories_joined_with_businesses) {SidCategory.left_outer_join_businesses}
      it "returns categories with and without businesses" do 
        expect(categories_joined_with_businesses).to eq([category_with_businesses, category_with_no_businesses])
      end
    end

    describe ".join_and_order_by_businesses_count" do 
      let!(:categories_ordered_by_businesses) {SidCategory.join_and_order_by_businesses_count}
      it "returns the category with the most businesses first" do 
        expect(categories_ordered_by_businesses.first).to eq(category_with_businesses)
      end

      it "returns the category with the least businesses last" do 
        expect(categories_ordered_by_businesses.last).to eq(category_with_no_businesses)
      end
    end

    describe ".with_businesses" do 
      let!(:categories_with_businesses) {SidCategory.with_businesses}
      it "returns only categories with businesses" do 
        expect(categories_with_businesses).to eq([category_with_businesses])
      end
    end
  end

  describe ".to_search_json" do 
    let!(:sid_category) {create(:sid_category)}
    it "should return search json" do 
      expect(sid_category.to_search_json).to eq({:label=>"Cool stuff to do.", 
                                                 :searchable_type=>"SID Category", 
                                                 :id=>"cool-stuff-to-do", 
                                                 :url=>"/category/cool-stuff-to-do"})
    end
  end
end
