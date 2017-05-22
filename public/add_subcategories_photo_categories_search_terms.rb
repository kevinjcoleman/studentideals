#require 'csv'
#
#CSV.parse(File.read('lib/BizId_PhotoCategory_SearchTerms.csv').scrub, headers: true)
#
#CSV.parse(File.read('lib/BizId_PhotoCategory_SearchTerms.csv').scrub, headers: true) do |row|
#  begin
#    business = Business.find_by(biz_id: row["biz_id"])
#    subcategory = SubCategory.find_by(photo_category: row["photo_category"])
#    business.add_sub_category(subcategory)
#    business.update_attributes!(photo_category_id: subcategory.id)
#    row['search_terms'].split(',').each do |term|
#      SearchTerm.add_search_term(term, business)
#    end
#  rescue => e
#    puts e.message
#    puts row
#  end
#end
