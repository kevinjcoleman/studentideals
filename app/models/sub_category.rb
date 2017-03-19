class SubCategory < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:label]
  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :label,
      [:label, :sid_category_id]
    ]
  end

  belongs_to :sid_category
  has_many :sub_category_taggings
  has_many :businesses, through: :sub_category_taggings

  validates_presence_of :sid_category, :label
  validates_uniqueness_of :label

  scope :left_outer_join_taggings, -> { joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id') }
  scope :left_outer_join_businesses, -> { left_outer_join_taggings.joins('left outer join businesses on sub_category_taggings.business_id = businesses.id') }
  scope :join_and_order_by_taggings_count, -> {   left_outer_join_taggings.
                                                  select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').
                                                  group('sub_categories.id').
                                                  order("taggings_count DESC") }

  scope :with_taggings, -> {join_and_order_by_taggings_count.having("count(sub_category_taggings.id) > 0")}

  BLACKLISTED_FACTUAL_CATEGORIES = ['Social',
                                    'Food and Dining',
                                    'Retail']

  def self.create_from_array(array, business)
    array -= BLACKLISTED_FACTUAL_CATEGORIES
    return if array.empty?
    @sub_category = self.find_or_create_by(label: array.first, sid_category_id: business.sid_category_id)
    business.add_sub_category(@sub_category)
    array.each do |cat|
      next if @sub_category.label == cat
      sub_category = self.create_with(parent: @sub_category).find_or_create_by(label: cat, sid_category_id: business.sid_category_id)
      business.add_sub_category(sub_category)
    end
  end

  def self.create_subcategory_and_tree_from_row(row, business)
    if row[:category_path] && !row[:label].empty?
      cats = row[:category_path].split('>').map {|c| c.strip }
      cats - BLACKLISTED_FACTUAL_CATEGORIES
      cats.each_cons(2) do |parent, child|
        parent_cat = self.add_or_update(label: parent, sid_category_id: business.sid_category_id)
        business.add_sub_category(parent_cat)
        category = self.add_or_update(parent: parent_cat, label: child, sid_category_id: business.sid_category_id)
        business.add_sub_category(category)
      end
      self.where(label: row[:label]).first.update_attributes!(row.except(:category_path, :label))
    else
      return if row[:category_path].in?(BLACKLISTED_FACTUAL_CATEGORIES)
      if sub_category = self.where(label: row[:category_path]).first
        sub_category.update_attributes!(row.except(:category_path, :label))
      else
        create_row = {label: row[:category_path], sid_category_id: business.sid_category_id}.merge({metadata_name: row[:metadata_name], metadata_value: row[:metadata_value]})
        category = SubCategory.create!(create_row)
        business.add_sub_category(category)
      end
    end
  end

  def self.add_or_update(args)
    if self.where(label: args[:label]).first
      self.where(label: args[:label]).first
    else
      self.create(args)
    end
  end

  def singularized_label
    label.split(" ").map(&:singularize).join(" ")
  end

  def each_with_children(&block)
    block.(self)
    children.each {|child| block.(child)}
  end

  def duplicates
    SubCategory.where(label: self.label).where.not(sid_category_id: self.sid_category_id)
  end
end
