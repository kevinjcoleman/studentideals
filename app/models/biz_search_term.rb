class BizSearchTerm < ActiveRecord::Base
  belongs_to :search_term
  belongs_to :business
end
