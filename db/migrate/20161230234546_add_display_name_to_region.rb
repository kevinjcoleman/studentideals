class AddDisplayNameToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :display_name, :string
  end
end
