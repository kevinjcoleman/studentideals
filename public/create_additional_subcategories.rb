#require 'csv'#

#CSV.foreach('lib/sid_additional_subcategories.csv', headers: true) do |row|
#  begin
#    if row['sub_cat_id']
#      SubCategory.find(row['sub_cat_id']).update_attributes!(photo_category: row['photo_category'])
#    elsif row["label"] && row["parent_id"]
#      parent = SubCategory.find(row["parent_id"])
#      SubCategory.create!(label: row["label"], photo_category: row['photo_category'], parent: parent, sid_category_id: parent.sid_category_id)
#    else
#      SubCategory.create!(label: row["label"], photo_category: row['photo_category'], sid_category_id: row['sid_category_id'])
#    end
#  rescue => e
#    puts e.message
#    puts row
#  end
#end
