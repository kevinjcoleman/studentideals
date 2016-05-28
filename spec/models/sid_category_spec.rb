require 'rails_helper'

RSpec.describe SidCategory, type: :model do
  describe ".create" do
    context "with valid info" do
      it "creates a category" do
        sid_category = create(:sid_category)
        expect(sid_category).to_not be_nil
      end
    end

    context "with incomplete info" do
      it "is invalid on missing label" do
        sid_category = build(:sid_category, label: nil)
        expect(sid_category).to_not be_valid       
      end

      it "is invalid on missing sid category id" do
        sid_category = build(:sid_category, sid_category_id: nil)
        expect(sid_category).to_not be_valid       
      end

      it "fails to create duplicate category" do
        create(:sid_category)
        begin
          sid_category = build(:sid_category)
        rescue
          expect(SidCategory.count).to eq 1   
        end
      end      
    end
  end
end
