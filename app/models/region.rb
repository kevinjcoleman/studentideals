class Region < ActiveRecord::Base
  include AddressMethods
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  include PgSearch
  multisearchable :against => [:name]

  validates_uniqueness_of :name
  validates :name, length: { minimum: 3 }, presence: true

  CLOSE_BIZ_COUNT_MINIMUM = 10
  scope :with_businesses, -> {where("close_biz_count > ?", CLOSE_BIZ_COUNT_MINIMUM)}


  def geojsonify(color:)
    marker_color = Color.fetch_color(color)
    geojson = {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [longitude, latitude]
      },
      properties: {
        name: name,
        icon: {
          iconUrl: 'https://s3-us-west-1.amazonaws.com/studentidealswebapp/uploads/images/location.png',
          iconSize: [50, 50], # size of the icon
          iconAnchor: [25, 25], # point of the icon which will correspond to marker's location
          popupAnchor: [0, -25], # point from which the popup should open relative to the iconAnchor
          className: 'current-location'
        }
      }
    }
  end

  def cache_biz_count
    self.close_biz_count = Business.geocoded.within(5, :origin => self).count
    self.save!
  end

  def to_search_json
    {label: name,
     searchable_type: "Locale",
     id: slug,
     url: "/region/#{slug}"}
  end
end
