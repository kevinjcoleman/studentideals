class CreateBizHours < ActiveRecord::Migration
  def change
    create_table :biz_hours do |t|
      t.references :business, index: true, foreign_key: true
      t.integer :day
      t.datetime :open_at
      t.datetime :close_at

      t.timestamps null: false
    end
  end
end
