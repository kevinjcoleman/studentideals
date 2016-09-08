class AddCloseBizCountToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :close_biz_count, :integer
  end
end
