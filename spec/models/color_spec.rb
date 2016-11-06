require 'rails_helper'

RSpec.describe Color, type: :model do
  describe "fetch_color" do 
    context "blue" do 
      it "should return #229AD6" do 
        expect(Color.fetch_color("blue")).to eq("#229AD6")
      end
    end

    context "orange" do 
      it "should return #FF9000" do 
        expect(Color.fetch_color("orange")).to eq("#FF9000")
      end
    end

    context "something else" do 
      it "raises an error" do 
        expect { Color.fetch_color("red") }.to raise_error "That's not a currently supported color."
      end
    end
  end
end