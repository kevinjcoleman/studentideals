require 'rails_helper'

RSpec.describe RegionController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      region = create(:region)
      get :show, id: region.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #index" do
    it "returns a list of regions on no exact match" do
      region = create(:region)
      region = create(:region, name: "Union Station")
      get :index, region_name: "U"
      expect(response).to render_template(:index)
    end

    it "redirects to a specific region a on exact match" do
      region = create(:region)
      get :index, region_name: region.name
      expect(response).to redirect_to '/region/ucla'
    end
  end
end
