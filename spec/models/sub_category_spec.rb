require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  it { should belong_to(:sid_category) }
  it { should have_many(:sub_category_taggings) }
  it { should have_many(:businesses).through(:sub_category_taggings) }
  it { should validate_presence_of(:sid_category) }
  it { should validate_presence_of(:label) }
  it { should validate_uniqueness_of(:label) }

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

  describe "#create_subcategory_and_tree_from_row" do
    let!(:business) {create(:business, :with_category)}
    let!(:sub_category_hash) {{metadata_name: "mcategory_ids",
                               metadata_value: "466",
                               label: "Optometrist",
                               category_path: "Healthcare > Optometrist"}}

    context "with a category path" do
      describe "nonexistant category" do
        before do
          SubCategory.create_subcategory_and_tree_from_row(sub_category_hash, business)
          @sub_category = SubCategory.find_by_label("Optometrist")
        end

        it "creates the parent" do
          expect(SubCategory.find_by_label("Healthcare")).to_not be_nil
        end

        it "creates the sub_category" do
          expect(@sub_category).to_not be_nil
        end

        it "adds the parent" do
          expect(@sub_category.parent.label).to eq("Healthcare")
        end

        it "has metadata" do
          expect(@sub_category.metadata_name).to_not be_nil
          expect(@sub_category.metadata_value).to_not be_nil
        end
      end

      describe "existing category" do
        let!(:parent) {create(:sub_category, label: "Healthcare", sid_category: business.sid_category)}
        let!(:sub_category) {create(:sub_category, label: "Optometrist", parent: parent, sid_category: business.sid_category)}

        before do
          SubCategory.create_subcategory_and_tree_from_row(sub_category_hash, business)
          @sub_category = SubCategory.find_by_label("Optometrist")
        end

        it "updates the sub_category" do
          expect(@sub_category).to_not be_nil
        end

        it "has metadata" do
          expect(@sub_category.metadata_name).to_not be_nil
          expect(@sub_category.metadata_value).to_not be_nil
        end
      end
    end

    context "without a category path" do
      let!(:sub_category_hash_wo_path) {sub_category_hash.merge({category_path: "Healthcare", label: nil})}
      before do
        SubCategory.create_subcategory_and_tree_from_row(sub_category_hash_wo_path, business)
        @sub_category = SubCategory.find_by_label("Optometrist")
      end

      it "creates the sub_category" do
        expect(@sub_category).to_not be_nil
      end

      it "has no parent" do
        expect(@sub_category.parent).to be_nil
      end

      it "has metadata" do
        expect(@sub_category.metadata_name).to_not be_nil
        expect(@sub_category.metadata_value).to_not be_nil
      end
    end
  end
end
