require 'rails_helper'

RSpec.describe Business, type: :model do
  context "valid business" do
    it "creates with valid attributes" do
      business = create(:business)
      expect(business).to_not be_nil
    end
  end
end
