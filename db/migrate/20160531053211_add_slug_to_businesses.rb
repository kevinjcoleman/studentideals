class AddSlugToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :slug, :string
    add_index :businesses, :slug, unique: true

    add_column :sid_categories, :slug, :string
    add_index :sid_categories, :slug, unique: true

    add_column :regions, :slug, :string
    add_index :regions, :slug, unique: true    
  end
end
