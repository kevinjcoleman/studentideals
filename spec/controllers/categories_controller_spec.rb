require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:region) {create(:region, :occidental)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}
  let!(:business) {update_biz_with_address(category)}
  let(:sub_category) {category.sub_categories.first}

  def subcategory_id
    category.sub_categories.first.id
  end

  describe "GET #show" do
    before do
      add_sub_category_tagging(business, category)
      get :show, region_id: region.id, id: category.id
    end

    it { should respond_with(:success) }

    it "assigns the category" do
      expect(assigns(:category)).to eq(category)
    end

    it "assigns the region" do
      expect(assigns(:region)).to eq(region)
    end

    it "assigns the first business" do
      expect(assigns(:businesses).first).to eq(business)
    end

    it "assigns the first sub_category" do
      expect(assigns(:sub_categories).first).to eq(sub_category)
    end
  end

  describe "GET #sub_show" do
    before do
       add_sub_category_tagging(business, category)
       create_subcategory_children(business, sub_category)
       get :sub_show, region_id: region.id, category_id: category.id, id: subcategory_id
    end

    it { should respond_with(:success) }

    it "assigns the category" do
      expect(assigns(:category)).to eq(category)
    end

    it "assigns the region" do
      expect(assigns(:region)).to eq(region)
    end

    it "assigns the first business" do
      expect(assigns(:businesses).first).to eq(business)
    end

    it "assigns correct sub_category" do
      expect(assigns(:sub_category)).to eq(sub_category)
    end

    it "assigns correct sub_categories" do
      expect(assigns(:sub_category).children.first.label).to eq("Pizza")
    end
  end

  describe "GET #list" do
    before { get :list, id: category.id }
    it { should respond_with(:success) }

    it "assigns the category" do
      expect(assigns(:category)).to eq(category)
    end

    it "assigns the first sub_category" do
      expect(assigns(:sub_categories).first).to eq(sub_category)
    end

    it "assigns the right state" do
      expect(assigns(:states).first.state).to eq("CA")
    end
  end

  describe "GET #sub_list" do
    before do
      add_sub_category_tagging(business, category)
      create_subcategory_children(business, sub_category)
      get :sub_list, category_id: category.id, id: subcategory_id
    end

    it { should respond_with(:success) }
    it "assigns the category" do
      expect(assigns(:category)).to eq(category)
    end

    it "assigns correct sub_category" do
      expect(assigns(:sub_category)).to eq(sub_category)
    end

    it "assigns the right state" do
      expect(assigns(:states).first.state).to eq("CA")
    end

    it "assigns correct sub_categories" do
      expect(assigns(:children).first.label).to eq("Pizza")
    end
  end

  def update_biz_with_address(category)
    business = category.businesses.first
    business.update_attributes!(attributes_for(:business, :with_ungeocoded_address, :with_lat_lng))
    business.reload
  end

  def add_sub_category_tagging(business, category)
    business.sub_category_taggings.create(sub_category: category.sub_categories.first)
  end

  def create_subcategory_children(business, sub_category)
    sub_sub_category = SubCategory.create_with(parent: sub_category).find_or_create_by(label: "Pizza", sid_category_id: business.sid_category_id)
    sub_sub_category.sub_category_taggings.create(business: business)
    sub_sub_category.reload
  end
end
