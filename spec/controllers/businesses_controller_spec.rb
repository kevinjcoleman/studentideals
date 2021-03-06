require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      region = create(:region)
      business = create(:business, :with_category, region_id: region.id)
      get :show, id: business.id
      expect(response).to have_http_status(:success)
    end
  end
end
