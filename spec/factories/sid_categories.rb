FactoryGirl.define do
  factory :sid_category do
    sid_category_id "3"
    label "Cool stuff to do."
    order 1

    trait :category_with_businesses do
      after(:create) do |category, evaluator|
        create_list(:business, 1, sid_category: category)
      end
    end

    trait :category_with_sub_category do
      after(:create) do |category, evaluator|
        create_list(:sub_category, 1, sid_category: category)
      end
    end
  end
end
