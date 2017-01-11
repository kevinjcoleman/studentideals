require 'rails_helper'

describe "homepage experience", :type => :feature, :js => true do
  let!(:region) {create(:region, :occidental)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}
  let!(:business) {update_biz_with_address(category)}
  let(:sub_category) {category.sub_categories.first}
  before do
    business.update_attributes!(biz_id: 1, region_id: region.id)
    create(:deal)
    add_sub_category_tagging(business, category)
    create_subcategory_children(business, sub_category)
  end

  it "has correct content" do
    visit root_path
    expect(page).to have_content 'Get more when you go out.'
    # Close popup
    click_on('Close')
    # Open biz category dropdown and click on category.
    find('.toggler', text: 'Business Categories').click
    find('.list-item', text: category.label).click
    # Click on sub_category
    click_on("Restaurants")
    # Click on sub_category's child
    click_on("Pizza")
    # Click on the state
    click_on("CA")
    # Click on a region
    find('.list-item').find('a', text:region.city).click
    #Click thourgh to the business
    binding.pry
    click_on(business.biz_name)
    # To save a screenshot of the test's current progress page.save_screenshot('afterclick7.png', :full => true)
  end
end
