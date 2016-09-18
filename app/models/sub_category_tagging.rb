class SubCategoryTagging < ActiveRecord::Base
  belongs_to :business
  belongs_to :sub_category

  validates_presence_of :business, :sub_category
  validates_uniqueness_of :business_id, scope: :sub_category_id
  validates_uniqueness_of :sub_category_id, scope: :business_id
end
