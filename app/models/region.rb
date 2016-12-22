class Region < ActiveRecord::Base
  include AddressMethods
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  include PgSearch
  multisearchable :against => [:name]

  validates_uniqueness_of :name
  validates :name, length: { minimum: 3 }, presence: true

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
        :'marker-color' => marker_color,
        :'marker-size' => 'medium'
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
