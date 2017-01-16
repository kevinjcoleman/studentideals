class AddTimeZoneHoursToBizHours < ActiveRecord::Migration
  def change
    change_column :biz_hours, :open_at, :time
    change_column :biz_hours, :close_at, :time
  end

end
