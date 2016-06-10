describe "homepage experience", :type => :feature, :js => true do
  it "it is searchable" do
    visit '/'
    within(".homepage-search") do
      fill_in 'region_name', :with => 'UCLA'
    end
    expect(page).to have_css('ui-menu-item', text: "UCLA")
  end
end