class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.references :sid_category, index: true, foreign_key: true
      t.string :label
      t.string :ancestry, index: true

      t.timestamps null: false
    end
  end
end
