require 'rails_helper'

RSpec.describe Signup, type: :model do
  it { should validate_presence_of(:email) }

  context "#create" do
    it "should not allow improperly formatted emails" do
      expect(Signup.new(email: "student").valid?).to be_falsey
    end

    it "should allow properly formatted emails" do
      expect(Signup.new(email: "student@school.edu").valid?).to be_truthy
    end
  end
end
