class CategoriesController < ApplicationController
  def show
    @category = SidCategory.find(params[:id])
    @businesses = @category.businesses.paginate(:page => params[:page])
  end
end
