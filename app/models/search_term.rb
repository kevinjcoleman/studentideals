class SearchTerm < ActiveRecord::Base
   has_many :biz_search_terms
   has_many :businesses, through: :biz_search_terms

   validates :term, presence: true, uniqueness: true

   def self.add_search_term(term, business)
      search_term = where(term: term).first_or_create
      search_term.biz_search_terms.create!(search_term: search_term, business: business) unless business.in? search_term.businesses
   end
end
