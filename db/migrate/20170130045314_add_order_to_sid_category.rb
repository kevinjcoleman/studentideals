class AddOrderToSidCategory < ActiveRecord::Migration
  def change
    add_column :sid_categories, :order, :integer
  end
end
