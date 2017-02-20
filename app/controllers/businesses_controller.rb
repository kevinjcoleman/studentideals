class BusinessesController < ApplicationController
  add_breadcrumb "Home", :root_path
  respond_to :html, :js

  def show
    @business = Business.includes(:hours, :deals).find(params[:id])
    @region = @business.region
    @category = SidCategory.find(@business.sid_category_id)
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @category.label, region_and_category_path(@region, @category)
    add_breadcrumb @business.biz_name, business_path(@business)
    @close_similar_businesses = @category.businesses.geocoded.where("id != ?", @business.id).within(5, :origin => @business).by_distance(:origin => @business).limit(2)
    @close_businesses = Business.includes(:sid_category).geocoded.where("id not IN (?)", @close_similar_businesses.map {|b| b.id }.push(@business.id)).within(5, :origin => @business).by_distance(:origin => @business).limit(2)
    @other_businesses_lat_lng_array = (@close_similar_businesses + @close_businesses).map {|b| b.lat_lng_to_a }.push(@business.lat_lng_to_a)
    respond_to do |format|
      format.json { render json: [@business.geojsonify(color: "orange-big")] + (@close_similar_businesses + @close_businesses).map {|b| b.geojsonify(color: "orange")}}  # respond with the created JSON object
      format.html
    end
  end

  def redirect
    redirect_to business_path(params[:business_id])
  end
end
