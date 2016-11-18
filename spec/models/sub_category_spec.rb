require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  it { should belong_to(:sid_category) }
  it { should have_many(:sub_category_taggings) }
  it { should have_many(:businesses).through(:sub_category_taggings) }
  it { should validate_presence_of(:sid_category) }
  it { should validate_presence_of(:label) }
  it { should validate_uniqueness_of(:label).scoped_to(:sid_category_id) }

  describe "ancestry stuff" do 
    let!(:sub_category) { create(:sub_category) }
    context "root sub_category" do
      it "returns as root" do
        expect(sub_category.root?).to be true
      end

      it "has a sid_category" do
        expect(sub_category.sid_category).to eq(SidCategory.first)
      end

      it "takes child categories" do 
        sub_category.children.create(label: "American", sid_category: sub_category.sid_category)
        expect(sub_category.children.first).to eq(SubCategory.find_by(label: "American"))
      end
    end
  end

  describe "additions from array" do
    let!(:business) {create(:business, :with_category)}
    it  "creates new sub_categories" do
      SubCategory.create_from_array(["Restaurants", "American"], business)
      root_sub_cat = SubCategory.roots.first
      expect(root_sub_cat.label).to eq("Restaurants")
      expect(root_sub_cat.children.first.label).to eq("American")
    end

    it "doesn't create any categories from the blacklist" do 
      SubCategory.create_from_array(["Social", "Food and Dining", "Restaurants", "American"], business)
      root_sub_cat = SubCategory.roots.first
      expect(root_sub_cat.label).to eq("Restaurants")
    end

    it "doesn't create duplicate categories" do
      SubCategory.create_from_array(["Restaurants", "American"], business)
      SubCategory.create_from_array(["Restaurants", "American"], business)
      expect(SubCategory.count).to eq 2
    end

    it "succesfully adds taggings" do
      SubCategory.create_from_array(["Restaurants", "American"], business)
      expect(business.sub_categories.roots.count).to eq 1
      expect(business.sub_categories.roots.first.label).to eq "Restaurants"
    end
  end

  context "scopes" do 
    let!(:sub_category_with_tagging) {create(:sub_category, :sub_category_with_tagging)}
    let!(:sub_category_without_tagging) {create(:sub_category, label: "Pizza", sid_category: sub_category_with_tagging.sid_category)}
    describe ".left_outer_join_taggings" do 
      let!(:sub_categories_joined_with_taggings) {SubCategory.left_outer_join_taggings}
      it "returns sub categories with and without taggings" do 
        expect(sub_categories_joined_with_taggings).to eq([sub_category_with_tagging, sub_category_without_tagging])
      end
    end

    describe ".left_outer_join_businesses" do 
      let!(:sub_categories_joined_businesses) {SubCategory.left_outer_join_businesses}
      it "returns categories with and without businesses" do 
        expect(sub_categories_joined_businesses).to eq([sub_category_with_tagging, sub_category_without_tagging])
      end
    end

    describe ".join_and_order_by_taggings_count" do 
      let!(:sub_categories_ordered_by_taggings) {SubCategory.join_and_order_by_taggings_count}
      it "returns the category with the most businesses first" do 
        expect(sub_categories_ordered_by_taggings.first).to eq(sub_category_with_tagging)
      end

      it "returns the category with the least businesses last" do 
        expect(sub_categories_ordered_by_taggings.last).to eq(sub_category_without_tagging)
      end
    end

    describe ".with_taggings" do 
      let!(:sub_categories_with_businesses) {SubCategory.with_taggings}
      it "returns only categories with businesses" do 
        expect(sub_categories_with_businesses).to eq([sub_category_with_tagging])
      end
    end
  end

  describe ".to_search_json" do 
    let!(:sub_category) { create(:sub_category) }
    it "returns search json" do 
      expect(sub_category.to_search_json).to eq({:label=>"Restaurants", 
                                                 :searchable_type=>"Category", 
                                                 :id=>"restaurants", 
                                                 :url=>"/category/cool-stuff-to-do/sub_category/restaurants"})
    end
  end
end
