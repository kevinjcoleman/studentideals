require 'rails_helper'

describe "homepage experience", :type => :feature, :js => true do
  let!(:region) {create(:region, :occidental)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}
  let!(:business) {update_biz_with_address(category)}
  let(:sub_category) {category.sub_categories.first}
  before do
    business.update_attributes(biz_id: 1)
    create(:deal)
    add_sub_category_tagging(business, category)
    create_subcategory_children(business, sub_category)
  end
  it "has correct content" do
    visit root_path
    expect(page).to have_content 'Get more when you go out.'
    click_on('Close')
    find('.toggler', text: 'Business Categories').click
    page.save_screenshot('afterclick.png', :full => true)
    find('.list-item', text: category.label).click
    page.save_screenshot('afterclick2.png', :full => true)
    click_on("Restaurants")
    page.save_screenshot('afterclick3.png', :full => true)
    click_on("Pizza")
    page.save_screenshot('afterclick4.png', :full => true)
    click_on("CA")
    page.save_screenshot('afterclick5.png', :full => true)
    find('.list-item').find('a', text:region.city).click
    page.save_screenshot('afterclick6.png', :full => true)
    click_on(business.biz_name)
    page.save_screenshot('afterclick7.png', :full => true)
  end
end
