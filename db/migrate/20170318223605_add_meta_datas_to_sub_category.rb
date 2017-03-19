class AddMetaDatasToSubCategory < ActiveRecord::Migration
  def change
    add_column :sub_categories, :metadata_name, :string
    add_column :sub_categories, :metadata_value, :string
  end
end
