class AddRegionToBusinesses < ActiveRecord::Migration
  def change
    add_reference :businesses, :region, index: true, foreign_key: true
  end
end
