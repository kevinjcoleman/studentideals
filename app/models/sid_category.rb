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

  scope :left_outer_join_businesses, -> {joins('left outer join businesses on businesses.sid_category_id = sid_categories.id')}
  scope :join_and_order_by_businesses_count, -> { select('sid_categories.*, 
                                                          count(businesses.id) as business_count').
                                                  left_outer_join_businesses.
                                                  group('sid_categories.id').
                                                  order("business_count DESC") } 
  scope :with_businesses, -> {join_and_order_by_businesses_count.having("count(businesses.id) > 0")}

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
