class SidCategory < ActiveRecord::Base
  validates :label, length: { minimum: 3 }, presence: true
  validates :sid_category_id, presence: true
  has_many :businesses

  def custom_sid_label
    label
  end
end
