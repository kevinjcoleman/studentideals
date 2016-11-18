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
  has_many :deals, foreign_key: "biz_id", primary_key: "biz_id"

  scope :without_sid_category, -> { where(sid_category_id: nil) }
  scope :with_factual, -> { where("external_id is not null") }
  scope :no_sub_categories, -> { joins('LEFT OUTER JOIN sub_category_taggings ON businesses.id = sub_category_taggings.business_id').
                                 group('businesses.id').
                                 having('count(sub_category_taggings.id) = 0')}
  scope :group_by_city, -> { group("businesses.city").
                             select("businesses.city, count(businesses.id) as count").
                             order("count DESC") }
  scope :with_specific_sub_category, ->(sub_category) { joins(:sub_category_taggings).
                                                        where(sub_category_taggings: {sub_category_id: sub_category.id})}

  def before_import_save(record)
    self.add_sid_category(record[:sid_category_data]) if record[:sid_category_data]
  end

  def add_sid_category(id)
    category = SidCategory.find_by(sid_category_id: id)
    raise ArgumentError, "Category doesn't exist!" if !category
    self.sid_category_id = category.id
  end

  def add_sub_category(category)
    sub_category_taggings.create(sub_category: category) unless category.in? sub_categories
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
    marker_color = Color.fetch_color(color)
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
      response = client.find_business(external_id)
      response["category_labels"].each do |category_array|
        SubCategory.create_from_array(category_array, self)
      end
    rescue => e
      parsed_error = JSON.parse(e.message)
      puts parsed_error["message"]
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

  def deal 
    deals.first
  end

  def website_description
    Linkify.new(sid_editorial).add_links.html_safe
  end

  def to_search_json
    {label: biz_name, 
     searchable_type: "Business",
     id: slug,
     url: "/region/#{region.slug}/businesses/#{slug}"}
  end
end
