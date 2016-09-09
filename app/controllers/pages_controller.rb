class PagesController < ApplicationController
  def home
    @categories = SidCategory.select('sid_categories.*, count(businesses.id) as business_count').joins('left outer join businesses on businesses.sid_category_id = sid_categories.id').group('sid_categories.id').order("business_count DESC")
    @states = Business.where("state IS NOT NULL").group("state").select("state, count(id) as count").order("count DESC").limit(5)
  end
end
