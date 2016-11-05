require 'rails_helper'

RSpec.describe Linkify, type: :model do
  let!(:link) {Linkify.new("Test content with link https://www.freecodecamp.com/challenges/center-text-with-bootstrap")}
  
  describe ".parse" do 
    it "returns an array" do 
      expect(link.parse.class).to be Array
    end

    it "returns the correct array" do 
      expect(link.parse).to eq(%w(Test content with link https://www.freecodecamp.com/challenges/center-text-with-bootstrap))
    end
  end
end