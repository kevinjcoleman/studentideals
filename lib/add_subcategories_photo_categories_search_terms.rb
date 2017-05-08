require 'csv'

CSV.foreach('lib/BizId_PhotoCategory_SearchTerms.csv', headers: true) do |row|
  business = Business.find_by(biz_id: row["biz_id"])
  subcategory = SubCategory.find_by(photo_category: row["photo_category"])
  business.add_sub_category(subcategory)
  business.update_attributes!(photo_category_id: subcategory.id)
  row['search_terms'].split(',').each do |term|
    SearchTerm.add_search_term(term, business)
  end
end
