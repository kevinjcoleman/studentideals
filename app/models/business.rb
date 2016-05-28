class Business < ActiveRecord::Base
  validates :biz_name, length: { minimum: 3 }, presence: true

end
