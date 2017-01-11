FactoryGirl.define do
  factory :region do
    name "UCLA"
    address1 "405 Hilgard Avenue"
    address2 nil
    city "Los Angeles"
    state "CA"
    zip "90095"
    country_code "US"
    trait :occidental do
      name "Occidental"
      address1 "1600 Alumni Avenue"
      address2 "Apt 8-201"
      city "Los Angeles"
      state "CA"
      zip "90041"
      country_code "US"
    end
    trait :school do
      type "School"
    end
    trait :locale do
      type "Locale"
    end
    trait :with_lat_lng do
      latitude 34.1253012
      longitude -118.2166504
    end
  end
end
