require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  describe "GET #show" do
   before { get :show, state_code: "CA" }
   it { should respond_with(:success) }
  end
end
