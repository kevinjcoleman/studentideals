class Business < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :biz_name,
      [:biz_name, :city],
      [:biz_name, :city, :state],
      [:biz_name, :city, :state, :address1]
    ]
  end

  validates :biz_name, length: { minimum: 3 }, presence: true
  belongs_to :sid_category

  geocoded_by :full_address
  after_validation :geocode

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude,
                   :distance_field_name => :distance

  scope :without_sid_category, -> { where(sid_category_id: nil) }
  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }

  def before_import_save(record)
    self.add_sid_category(record[:sid_category_data]) if record[:sid_category_data]
  end

  def add_sid_category(id)
    category = SidCategory.find_by(sid_category_id: id)
    self.sid_category_id = category.id
  end

  # Used for Rails Admin instances of model
  def custom_biz_label
    "#{biz_name}"
  end

  def lat_lng
    latitude + longitude
  end

  def full_address
    if city && state
      "#{geocode_address1}#{geocode_address2}#{geocode_city}#{geocode_state}#{geocode_zip}#{geocode_country_code}"
    end
  end

  def geocode_address1
    address1 ? "#{address1}" : nil
  end

  def geocode_address2
    address2 ? ", #{address2}" : nil
  end

  def geocode_city
    city ? ", #{city}" : nil
  end

  def geocode_state
    state ? ", #{state}" : nil
  end

  def geocode_zip
    zip ? ", #{zip}" : nil
  end

  def geocode_country_code
    country_code ? ", #{country_code}" : nil
  end
end
