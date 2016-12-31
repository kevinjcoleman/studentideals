class AddSchoolIdToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :school_id, :integer
    add_index :regions, :school_id, unique: true
  end
end
