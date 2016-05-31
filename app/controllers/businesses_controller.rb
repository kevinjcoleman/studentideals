class BusinessesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @region = Region.find(params[:region_id])
    @business = Business.find(params[:id])
    @category = SidCategory.find(@business.sid_category_id)
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @category.label, region_category_path(@region, @category)
    add_breadcrumb @business.biz_name, region_business_path(@region, @business)
  end
end
