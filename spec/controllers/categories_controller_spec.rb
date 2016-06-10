require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      region = create(:region)
      category = create(:sid_category)
      get :show, region_id: region.id, id: category.id
      expect(response).to have_http_status(:success)
    end
  end
end
