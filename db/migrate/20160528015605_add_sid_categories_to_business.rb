class AddSidCategoriesToBusiness < ActiveRecord::Migration
  def change
    add_reference :businesses, :sid_category, index: true, foreign_key: true
  end
end
