require "spec_helper" 
include ApplicationHelper
include FontAwesome::Rails::IconHelper

describe ApplicationHelper, :type => :helper do
  describe "#logo" do
    it "returns more" do
      expect(logo(SidCategory::MORE.to_s)).to eq "<i class=\"fa fa-rocket\"></i>"
    end

    it "returns health" do
      expect(logo(SidCategory::HEALTH.to_s)).to eq "<i class=\"fa fa-heart\"></i>"
    end

    it "returns something to do" do
      expect(logo(SidCategory::SOMETHINGTODO.to_s)).to eq "<i class=\"fa fa-bolt\"></i>"
    end

    it "returns food" do
      expect(logo(SidCategory::FOOD.to_s)).to eq "<i class=\"fa fa-glass\"></i>"
    end

    it "returns shopping" do
      expect(logo(SidCategory::SHOPPING.to_s)).to eq "<i class=\"fa fa-shopping-bag\"></i>"
    end

    it "returns question" do
      expect(logo("something else")).to eq "<i class=\"fa fa-question\"></i>"
    end
  end

  describe "alert_class_for" do 
    it "should return the correct flash types" do
      ApplicationHelper::FLASH_TYPES.each do |k, v|
        expect(alert_class_for(k.to_s)).to eq(v)
      end
    end

    it "should return something else if not flash type" do 
      expect(alert_class_for("other-type")).to eq("alert-other-type")
    end
  end
end