require 'csv'

CSV.foreach('lib/sid_additional_subcategories.csv', headers: true) do |row|
  business = Business.find(row["biz_id"])
  subcategory = SubCategory.find_by(photo_category: row["photo_category"])
  business.add_sub_category(subcategory)
  business.update_attributes!(photo_category: subcategory)
  row['search_terms'].split(',').each do |term|
    search_term = SearchTerm.where(term: term.strip).first_or_create
  end
end
