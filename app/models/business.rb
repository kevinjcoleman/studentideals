class Business < ActiveRecord::Base
  include AddressMethods

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

  scope :without_sid_category, -> { where(sid_category_id: nil) }

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

  def geojsonify
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [self.longitude, self.latitude]
      },
      properties: {
        name: self.name,
        :'marker-color' => '#38ABD1',
        :'marker-symbol' => 'star-stroked',
        :'marker-size' => 'large'
      }
    }
  end
end
