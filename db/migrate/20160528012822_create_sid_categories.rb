class CreateSidCategories < ActiveRecord::Migration
  def change
    create_table :sid_categories do |t|
      t.string :sid_category_id
      t.string :label

      t.timestamps null: false
    end
    add_index :sid_categories, :sid_category_id, unique: true
  end
end
