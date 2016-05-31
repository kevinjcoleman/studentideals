class CategoriesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @region = Region.find(params[:region_id])
    @category = SidCategory.includes(:businesses).find(params[:id])
    @businesses_all = @category.businesses.geocoded.within(5, :origin => @region).by_distance(:origin => @region)
    @businesses = @businesses_all.page params[:page]
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @category.label, region_category_path(@region, @category)
  end
end