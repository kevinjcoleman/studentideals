class Region < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  validates_uniqueness_of :name
  validates :name, length: { minimum: 3 }, presence: true
  
  geocoded_by :full_address
  after_validation :geocode

  def lat_lng
    latitude.to_s + ", " + longitude.to_s
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
