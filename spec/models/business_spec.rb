require 'rails_helper'

RSpec.describe Business, type: :model do
  describe ".create" do
    context "with good info" do
      it "creates with valid attributes" do
        business = create(:business)
        expect(business).to_not be_nil
      end
    end

    context "bad info" do
      it "is invalid w/o name" do
        business = build(:business, biz_name: nil)
        expect(business).to_not be_valid
      end

      it "is invalid with short name" do
        business = build(:business, biz_name: "KC")
        expect(business).to_not be_valid
      end
    end
  end

end
