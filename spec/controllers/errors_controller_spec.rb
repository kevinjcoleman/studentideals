require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  describe "GET #error404" do
    it "returns http success" do
      get :error404
      expect(response).to have_http_status(:success)
    end
  end

end
