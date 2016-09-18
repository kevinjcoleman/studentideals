class CreateSubCategoryTaggings < ActiveRecord::Migration
  def change
    create_table :sub_category_taggings do |t|
      t.references :business, index: true, foreign_key: true
      t.references :sub_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
