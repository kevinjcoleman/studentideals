require 'rails_helper'

RSpec.describe IframeController, type: :controller do

  describe "GET #search_box" do
    it "returns http success" do
      get :search_box
      expect(response).to have_http_status(:success)
    end
  end

end
