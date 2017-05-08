class AddPhotoCategoryToSubCategories < ActiveRecord::Migration
  def change
    add_column :sub_categories, :photo_category, :string
  end
end
