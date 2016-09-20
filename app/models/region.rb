class Region < ActiveRecord::Base
  include AddressMethods
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  include PgSearch
  multisearchable :against => [:name]
  
  validates_uniqueness_of :name
  validates :name, length: { minimum: 3 }, presence: true

  def geojsonify(color:)
    case color
      when "blue"
        marker_color = "#229AD6"
      when "orange"
        marker_color = "#FF9000"
      else
        raise ArgumentError, "That's not a currently supported color."
    end
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

end
