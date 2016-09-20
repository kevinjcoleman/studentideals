class SidCategory < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:label]
  
  extend FriendlyId
  friendly_id :label, use: [:slugged, :finders]

  validates_uniqueness_of :label, :sid_category_id
  validates :label, length: { minimum: 3 }, presence: true
  validates :sid_category_id, presence: true
  has_many :businesses
  has_many :sub_categories

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
