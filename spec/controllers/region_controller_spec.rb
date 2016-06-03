require 'rails_helper'

RSpec.describe RegionController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      region = create(:region)
      get :show, id: region.id
      expect(response).to have_http_status(:success)
    end
  end

end
