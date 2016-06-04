class Region < ActiveRecord::Base
  include AddressMethods
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  validates_uniqueness_of :name
  validates :name, length: { minimum: 3 }, presence: true

end
