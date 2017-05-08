class AddPhotoCategoriesToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :photo_category_id, :integer, index: true
  end
end
