class PagesController < ApplicationController
  def home
    @categories = SidCategory.all
    @states = Business.where("state IS NOT NULL").group("state").select("state, count(id) as count").order("count DESC").limit(5)
  end
end
