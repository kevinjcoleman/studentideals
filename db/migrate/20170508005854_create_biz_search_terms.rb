class CreateBizSearchTerms < ActiveRecord::Migration
  def change
    create_table :biz_search_terms do |t|
      t.references :search_term, index: true, foreign_key: true
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
