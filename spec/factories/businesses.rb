FactoryGirl.define do
  factory :business do
    biz_name "Testy Mctesterson's Tools"
    external_id "238e0c66-7025-4920-ba32-16ebda1926dd"
    biz_id "1"
    trait :with_ungeocoded_address do
      address1 "1600 Alumni Avenue"
      address2 "Apt 8-201"
      city "Los Angeles"
      state "CA"
      zip "90041"
      country_code "US"
    end
    trait :with_lat_lng do
      latitude 34.1253012
      longitude -118.2166504
    end
    trait :with_category do
      association :sid_category, :factory => :sid_category
    end

    trait :with_sub_category do
      after(:create) do |business, evaluator|
        business.sub_category_taggings.create(sub_category: create(:sub_category))
        business.update_attributes!(sid_category: business.sub_categories.first.sid_category)
      end
    end
  end
end
