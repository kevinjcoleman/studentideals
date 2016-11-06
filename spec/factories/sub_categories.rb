FactoryGirl.define do
  factory :sub_category do
    label "Restaurants"
    association :sid_category, :factory => :sid_category

    trait :sub_category_with_tagging do
      after(:create) do |sub_category, evaluator|
        business = create(:business)
        sub_category.sub_category_taggings.create(business: business)
      end
    end
  end
end
