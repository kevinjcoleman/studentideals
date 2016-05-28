class SidCategory < ActiveRecord::Base
  validates :label, length: { minimum: 3 }, presence: true
  validates :sid_category_id, presence: true
  has_many :businesses
end
