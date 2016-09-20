class AddFriendlyIdToSubCategories < ActiveRecord::Migration
  def change
    add_column :sub_categories, :slug, :string
    add_index :sub_categories, :slug, unique: true
  end
end
