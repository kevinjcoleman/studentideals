def add_sub_category_tagging(business, category)
  business.sub_category_taggings.create(sub_category: category.sub_categories.first)
end

def create_subcategory_children(business, sub_category)
  sub_sub_category = SubCategory.create_with(parent: sub_category).find_or_create_by(label: "Pizza", sid_category_id: business.sid_category_id)
  sub_sub_category.sub_category_taggings.create(business: business)
  sub_sub_category.reload
end

def update_biz_with_address(category)
  business = category.businesses.first
  business.update_attributes!(attributes_for(:business, :with_ungeocoded_address, :with_lat_lng))
  business.reload
end

def initialize_basic_objects
  let!(:region) {create(:region, :occidental)}
  let!(:category) {create(:sid_category, :category_with_businesses, :category_with_sub_category)}
  let!(:business) {update_biz_with_address(category)}
  let(:sub_category) {category.sub_categories.first}
  add_sub_category_tagging(business, category)
  create_subcategory_children(business, sub_category)
end
