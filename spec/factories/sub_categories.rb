FactoryGirl.define do
  factory :sub_category do
    label "Restaurants"
    association :sid_category, :factory => :sid_category
  end
end
