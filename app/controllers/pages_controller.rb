class PagesController < ApplicationController
  def home
    @categories = SidCategory.all.includes(:businesses)
  end
end
