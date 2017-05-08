require 'csv'

CSV.foreach('lib/BizId_PhotoCategory_SearchTerms.csv', headers: true) do |row|
  if row['sub_cat_id']
    SubCategory.find(row['sub_cat_id']).update_attributes!(photo_category: row['photo_category'])
  elsif row["Label"] && row["parent_id"]
    parent = SubCategory.find(row["parent_id"])
    SubCategory.create!(label: row["Label"], photo_category: row['photo_category'], parent: parent, sid_category_id: parent.sid_category_id)
  else
    SubCategory.create!(label: row["Label"], photo_category: row['photo_category'], sid_category_id: row['sid_category_id'])
  end
end
