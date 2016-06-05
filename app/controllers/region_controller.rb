class RegionController < ApplicationController
  autocomplete :region, :name
  add_breadcrumb "Home", :root_path
  respond_to :html, :js

  def show
    @region = Region.find(params[:id])
    @businesses_all = Business.geocoded.within(5, :origin => @region).by_distance(:origin => @region)
    @categories = SidCategory.where(id: @businesses_all.map {|b| b.sid_category_id}.uniq)
    @businesses = @businesses_all.page params[:page]
    add_breadcrumb @region.name, region_path(@region)
    respond_to do |format|
      format.json { render json: [@region.geojsonify(color: "blue")] + @businesses.map {|b| b.geojsonify(color: "orange")}}  # respond with the created JSON object
      format.html
    end
  end

  def index 
    if region_name = params[:region_name]
      @regions = Region.where("name LIKE ?", "#{region_name}%").page params[:page]
      if @regions.count == 1
        redirect_to region_path @regions.first
      end
    else
      @regions = Region.all.page params[:page]
    end
  end
end
