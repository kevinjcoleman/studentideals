require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:region) {create(:region)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}

  def subcategory_id
    category.sub_categories.first.id
  end

  describe "GET #show" do
    before { get :show, region_id: region.id, id: category.id }
    it { should respond_with(:success) }
  end

  describe "GET #sub_show" do
    before { get :sub_show, region_id: region.id, category_id: category.id, id: subcategory_id }
    it { should respond_with(:success) }
  end

  describe "GET #list" do
    before { get :list, id: category.id }
    it { should respond_with(:success) }
  end

  describe "GET #sub_list" do
    before { get :sub_list, category_id: category.id, id: subcategory_id }
    it { should respond_with(:success) }
  end
end
