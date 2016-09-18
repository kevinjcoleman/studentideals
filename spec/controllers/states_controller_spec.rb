require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  let!(:region) {create(:region)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}

  describe "GET #show" do
   before { get :show, state_code: "CA" }
   it { should respond_with(:success) }
  end

  describe "GET #show" do
   before { get :show_state_category, state_code: "CA",  category_id: category.id }
   it { should respond_with(:success) }
  end

  describe "GET #show" do
   before { get :show_state_category_sub_category, state_code: "CA",  category_id: category.id, sub_category_id: category.sub_categories.first.id  }
   it { should respond_with(:success) }
  end
end
