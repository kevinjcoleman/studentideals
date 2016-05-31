class RegionController < ApplicationController
  autocomplete :region, :name
  add_breadcrumb "Home", :root_path

  def show
    @region = Region.find(params[:id])
    @businesses_all = Business.near(@region.lat_lng)
    @categories = SidCategory.where(id: @businesses_all.map {|b| b.sid_category_id}.uniq)
    @businesses = @businesses_all.page params[:page]
    add_breadcrumb @region.name, region_path(@region)
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
