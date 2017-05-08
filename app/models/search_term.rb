class SearchTerm < ActiveRecord::Base
   has_many :biz_search_terms
   has_many :businesses, through: :biz_search_terms
end
