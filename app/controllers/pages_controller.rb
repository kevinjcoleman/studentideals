class PagesController < ApplicationController
  def home
    @categories = SidCategory.all.includes(:businesses)
    @regions = Region.order(close_biz_count: :DESC).limit(5)
  end
end
