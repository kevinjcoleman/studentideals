class Business < ActiveRecord::Base
  include AddressMethods
  include PgSearch
  multisearchable :against => [:biz_name]

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
  has_many :sub_category_taggings
  has_many :sub_categories, through: :sub_category_taggings

  scope :without_sid_category, -> { where(sid_category_id: nil) }
  scope :with_factual, -> { where("external_id is not null") }
  scope :no_sub_categories, -> { joins('LEFT OUTER JOIN sub_category_taggings ON businesses.id = sub_category_taggings.business_id').group('businesses.id').having('count(sub_category_taggings.id) = 0')}

  def before_import_save(record)
    self.add_sid_category(record[:sid_category_data]) if record[:sid_category_data]
  end

  def add_sid_category(id)
    category = SidCategory.find_by(sid_category_id: id)
    raise ArgumentError, "Category doesn't exist!" if !category
    self.sid_category_id = category.id
  end

  # Used for Rails Admin instances of model
  def custom_biz_label
    "#{biz_name}"
  end

  def find_region
    Region.where(city: city, state: state).first
  end

  def link
     Rails.application.routes.url_helpers.region_business_path(find_region, self)
  end

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
        url: link,
        name: biz_name,
        address: full_address,
        :'marker-color' => marker_color,
        :'marker-size' => 'medium'
      }
    }
  end

  def add_factual_categories(client=nil)
    client ||= FactualClient.new
    begin
      response = client.find_business(external_id)
      response["category_labels"].each do |category_array|
        SubCategory.create_from_array(category_array, self)
      end
    rescue => e
      if e =~ /There is no entity associated with the factual_id/
        puts "This record can't be found in factual"
      end
    end
  end

  def self.batch_add_factual_categories
    client = FactualClient.new
    uncategorized_businesses = Business.with_factual.no_sub_categories
    i = uncategorized_businesses.count.count
    uncategorized_businesses.each do |biz|
      i -= 1; p i if i % 25 == 0
      biz.add_factual_categories(client)
    end
  end

  def region
    Region.find_by(city: city, state:state)
  end
end
