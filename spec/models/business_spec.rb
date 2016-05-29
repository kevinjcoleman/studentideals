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

  describe "add SID category through sid_category_id" do
    before { @business = create(:business)}
    before { @category = create(:sid_category)}
    it "creates an associate with an existing sid_category_id" do
      @business.add_sid_category("3")
      @business.save
      expect(@business.sid_category).to eq @category
    end
  end

  describe "scopes" do
    context "without_sid_category" do
      before do
        create(:sid_category) 
        @business = create(:business)
        @business_without_category = create(:business)
        @business.add_sid_category("3")
        @business.save
      end

      it "returns businesses without categories" do
        without_categories = Business.without_sid_category
        expect(without_categories.find(@business_without_category.id)).to_not be_nil
      end

      it "doesn't return businesses with categories" do
        without_categories = Business.without_sid_category
        expect(without_categories.where(id: @business.id).first).to be_nil
      end
    end
  end

end
