require 'rails_helper'

RSpec.describe Linkify, type: :model do
  let(:with_link) {Linkify.new("Test content with link https://www.facebook.com/kevinjamescoleman.7")}
  let(:without_link) {Linkify.new("Test content without link.")}

  describe ".parse" do 
    it "returns an array" do 
      expect(with_link.parse.class).to be Array
    end

    it "returns the correct array" do 
      expect(with_link.parse).to eq(%w(Test content with link https://www.facebook.com/kevinjamescoleman.7))
    end
  end

  describe ".add_links" do 
    context "without links" do
      it "returns a string" do 
        expect(without_link.add_links.class).to be String
      end

      it "doesn't have an <a> tags." do 
        expect(without_link.add_links).to eq("Test content without link.")
      end
    end

    context "with links" do
      it "returns a string" do 
        expect(with_link.add_links.class).to be String
      end

      it "doesn't have an <a> tags." do 
        expect(with_link.add_links).to eq("Test content with link <a href=\"https://www.facebook.com/kevinjamescoleman.7\" target=\"_blank\">https://www.facebook.com/kevinjamescoleman.7</a>")
      end
    end
  end

  describe ".modify!" do 
    let(:link) {"https://www.facebook.com/kevinjamescoleman.7"}
    let(:string) {"Simple"}
    
    context "when not a link" do 
      it "returns the string" do 
        value = without_link.modify!(string)
        expect(value).to eq(string)
      end
    end

    context "when a link" do 
      it "returns an <a> link" do 
        value = with_link.modify!(link)
        expect(value).to eq("<a href=\"https://www.facebook.com/kevinjamescoleman.7\" target=\"_blank\">https://www.facebook.com/kevinjamescoleman.7</a>")
      end
    end
  end
end