class SidCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :label, use: [:slugged, :finders]

  validates :label, length: { minimum: 3 }, presence: true
  validates :sid_category_id, presence: true
  has_many :businesses

  CATEGORIES = [
    MORE = 5,
    HEALTH = 3,
    SOMETHINGTODO = 1,
    FOOD = 0,
    SHOPPING = 2
  ]

  def custom_sid_label
    label
  end

  def business_count
    Business.where(sid_category_id: id).count
  end
end
