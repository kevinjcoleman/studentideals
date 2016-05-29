class CategoriesController < ApplicationController
  def show
    @category = SidCategory.find(params[:id])
    @businesses = @category.businesses.page params[:page]
  end
end
