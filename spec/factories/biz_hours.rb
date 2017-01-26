FactoryGirl.define do
  factory :biz_hour do
    day 0
    association :business, :factory => :business
    open_at "10:00:00-08"
    close_at "21:00:00-08"
    timezone "pst"
  end
end
