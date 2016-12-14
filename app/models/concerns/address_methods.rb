module AddressMethods
  extend ActiveSupport::Concern
  DEFAULT_NEARBY_MILES = 5

  included do
    geocoded_by :full_address
    after_validation :geocode, if: ->(obj){ obj.full_address.present? && !obj.is_geocoded? }

    acts_as_mappable :lat_column_name => :latitude,
                    :lng_column_name => :longitude,
                    :distance_field_name => :distance

    scope :geocoded, -> { where("latitude is not NULL and longitude is not NULL AND latitude != 0.0 AND longitude != 0.0") }
    scope :ungeocoded, -> { where("(latitude is NULL and longitude is NULL) OR (latitude = 0.0 AND longitude = 0.0)") }
    scope :lat_long_of_zero, -> { where(latitude: 0.0, longitude: 0.0) }
    scope :nearby, -> (origin) {geocoded.within(DEFAULT_NEARBY_MILES, origin: origin).by_distance(origin: origin)}
  end

  def is_geocoded?
    (latitude != nil && latitude != 0.0) && (longitude != nil && longitude != 0.0)
  end

  def lat_lng_to_a
    return nil unless latitude && longitude
    [latitude, longitude]
  end

  def lat_lng
    return unless latitude && longitude
    latitude.to_s + ", " + longitude.to_s
  end

  def full_address
    if city && state
      "#{geocode_address1}#{geocode_address2}#{geocode_city}#{geocode_state}#{geocode_zip}#{geocode_country_code}"
    end
  end

  def address_line_1
    return unless address1 || address2
    "#{geocode_address1}#{geocode_address2}"
  end

  def address_line_2
    return unless (city || zip) && state
    "#{geocode_city}#{geocode_state}#{geocode_zip}#{geocode_country_code}".gsub(/^,/, '').strip
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
