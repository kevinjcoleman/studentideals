require 'rails_helper'

RSpec.describe SidCategory, type: :model do
  describe ".create" do
    let!(:sid_category) {create(:sid_category)}
    context "with valid info" do
      it { expect(sid_category).to_not be_nil }
    end

    context "with incomplete info" do
      it "is invalid on missing label" do
        expect(build(:sid_category,  sid_category_id: "12", label: nil)).to_not be_valid       
      end

      it "is invalid on missing sid category id" do
        expect(build(:sid_category, sid_category_id: nil, label: "Restaurants")).to_not be_valid       
      end

      it "fails to create duplicate category" do
        expect { create(:sid_category) }.to raise_error ActiveRecord::RecordInvalid
      end      
    end
  end
  
  context "#business_count" do
    let(:category_with_businesses) {create(:category_with_businesses)}
    let!(:unassociated_business) {create(:business, biz_name: "Ollivanders wand shop.")}
    let(:category_with_no_businesses) {create(:sid_category)}

    it "returns an count of businesses for category." do
      expect(category_with_businesses.business_count).to eq(1)
    end

    it "returns 0 if no businesses." do
      expect(category_with_no_businesses.business_count).to eq(0)
    end
  end
end
