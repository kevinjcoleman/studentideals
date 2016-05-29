class RegionController < ApplicationController
  autocomplete :region, :name

  def show
    @region = Region.find(params[:id])
    @businesses = Business.near(@region.lat_lng).page params[:page]
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
