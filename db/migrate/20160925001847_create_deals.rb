class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :deal_id
      t.integer :bizd_id
      t.string :desc_short
      t.string :desc_student
      t.text :details

      t.timestamps null: false
    end
    add_index :deals, :bizd_id
    add_index :deals, :deal_id, unique: true
  end
end
