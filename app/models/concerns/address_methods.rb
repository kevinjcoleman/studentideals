module AddressMethods
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_address
    after_validation :geocode

    acts_as_mappable :lat_column_name => :latitude,
                    :lng_column_name => :longitude,
                    :distance_field_name => :distance

    scope :geocoded, -> { where("latitude is not NULL and longitude is not NULL AND latitude != 0.0 AND longitude != 0.0") }
    scope :ungeocoded, -> { where("(latitude is NULL and longitude is NULL) OR (latitude = 0.0 AND longitude = 0.0)") }
  end

  def lat_lng_to_a
    [latitude, longitude]
  end

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