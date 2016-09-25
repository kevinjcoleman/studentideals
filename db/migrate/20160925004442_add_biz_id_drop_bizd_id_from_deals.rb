class AddBizIdDropBizdIdFromDeals < ActiveRecord::Migration
  def change
    add_column :deals, :biz_id, :integer
    remove_column :deals, :bizd_id, :integer

    add_index :deals, :biz_id
  end
end
