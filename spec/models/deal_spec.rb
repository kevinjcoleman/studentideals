require 'rails_helper'

RSpec.describe Deal, type: :model do
  it { should belong_to(:business) }
  it { should validate_presence_of(:desc_short) }

  describe "before_import_save" do
    let(:record) {{bizd_id: "2"}}

    it "should update biz_id on deal" do 
      deal = Deal.new()
      deal.before_import_save(record)
      expect(deal.biz_id).to eq(2)
    end
  end
end
