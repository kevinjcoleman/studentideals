class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :biz_name
      t.string :biz_id
      t.string :external_id

      t.timestamps null: false
    end
    add_index :businesses, :biz_id, unique: true
  end
end
