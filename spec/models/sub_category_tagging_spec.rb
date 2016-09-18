require 'rails_helper'

RSpec.describe SubCategoryTagging, type: :model do
  it { should belong_to(:sub_category) }
  it { should belong_to(:business) }
  it { should validate_presence_of(:sub_category) }
  it { should validate_presence_of(:business) }
  it { should validate_uniqueness_of(:business_id).scoped_to(:sub_category_id) }
  it { should validate_uniqueness_of(:sub_category_id).scoped_to(:business_id) }
end
