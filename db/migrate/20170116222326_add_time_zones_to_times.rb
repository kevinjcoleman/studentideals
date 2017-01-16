class AddTimeZonesToTimes < ActiveRecord::Migration
  def change
    change_column :biz_hours, :open_at, "time with time zone"
    change_column :biz_hours, :close_at, "time with time zone"
  end
end
