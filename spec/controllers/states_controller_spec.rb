require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  let!(:region) {create(:region)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}
  let!(:business) {update_biz_with_address(category)} 
  let(:sub_category) {category.sub_categories.first}

  describe "GET #show" do
    before { get :show, state_code: "CA" }
    it { should respond_with(:success) }
   
    it "should return a city" do 
      expect(assigns(:cities).first.city).to eq("Los Angeles")
    end

    it "should return a category" do 
      expect(assigns(:categories).first).to eq(category)
    end
  end

  describe "GET #show_state_and_category" do
    before do  
      add_sub_category_tagging(business, category)
      get :show_state_and_category, state_code: "CA",  category_id: category.id 
    end

    it { should respond_with(:success) }
    it "should return a city" do 
      expect(assigns(:cities).first.city).to eq("Los Angeles")
    end

    it "should return a category" do 
      expect(assigns(:category)).to eq(category)
    end

    it "should return a sub_category" do
      expect(assigns(:sub_categories).first).to eq(sub_category)
    end
  end

  describe "GET #show_state_category_and_subcategory" do
    before do 
      add_sub_category_tagging(business, category)
      @sub_sub_category = create_subcategory_children(business, sub_category)
      get :show_state_category_and_subcategory, state_code: "CA",  category_id: category.id, sub_category_id: sub_category.id  
    end
    it { should respond_with(:success) }
    it "should return a city" do 
      expect(assigns(:cities).first.city).to eq("Los Angeles")
    end

    it "should return a category" do 
      expect(assigns(:category)).to eq(category)
    end

    it "should return a sub_category" do
      expect(assigns(:sub_category)).to eq(sub_category)
    end

    it "should return the sub_category's children" do
      expect(assigns(:sub_categories).first).to eq(@sub_sub_category)
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
