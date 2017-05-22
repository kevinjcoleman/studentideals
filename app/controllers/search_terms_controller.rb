class SearchTermsController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @search_term, @region = SearchTerm.find(params[:id]), Region.find(params[:region_id])
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @search_term.term, region_and_search_term_path(@region, @search_term)
    @businesses_all = @search_term.businesses.nearby(@region)
    @businesses = @businesses_all.page params[:page]
    set_timezone
    respond_to do |format|
      format.json { render json: [@region.geojsonify(color: "blue")] + @businesses.map {|b| b.geojsonify(color: "orange")}}  # respond with the created JSON object
      format.html
    end
  end
end
