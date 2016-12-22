class AddTypeToRegion < ActiveRecord::Migration
  def up
    add_column :regions, :type, :string
    execute "UPDATE regions SET type = 'Locale' WHERE type IS NULL"
  end

  def down
    remove_column :regions, :type, :string
  end
end
