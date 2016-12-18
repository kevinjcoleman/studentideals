require 'rails_helper'

describe "splash feature experience", :type => :feature, :js => true do
  it "has splash modal" do
    visit root_path
    expect(find("#splash-modal").visible?).to be_truthy
  end
end
