class AddTimeZoneToBizHour < ActiveRecord::Migration
  def change
    add_column :biz_hours, :timezone, :integer
  end
end
