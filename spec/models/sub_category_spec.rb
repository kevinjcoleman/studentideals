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
end
