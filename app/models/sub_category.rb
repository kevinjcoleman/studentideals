class SubCategory < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:label]
  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :label,
      [:label, :sid_category_id]
    ]
  end

  belongs_to :sid_category
  has_many :sub_category_taggings
  has_many :businesses, through: :sub_category_taggings

  validates_presence_of :sid_category, :label
  validates_uniqueness_of :label, scope: :sid_category_id

  BLACKLISTED_FACTUAL_CATEGORIES = ['Social',
                                    'Food and Dining',
                                    'Retail']

  def self.create_from_array(array, business)
    array = array - BLACKLISTED_FACTUAL_CATEGORIES
    return if array.empty?
    @sub_category = self.find_or_create_by(label: array.first, sid_category_id: business.sid_category_id)
    @sub_category.sub_category_taggings.create(business: business) unless @sub_category.businesses.where(id: business.id).first
    array.each do |cat|
      next if @sub_category.label == cat
      @sub_category = self.create_with(parent: @sub_category).find_or_create_by(label: cat, sid_category_id: business.sid_category_id)
      @sub_category.sub_category_taggings.create(business: business) unless @sub_category.businesses.where(id: business.id).first
    end
  end
end
