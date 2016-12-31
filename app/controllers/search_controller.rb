class SearchController < ApplicationController
  def results
    @results = PgSearch.multisearch(params[:query]).limit(20)
    render_json
  end

  def locations
    if params[:query].empty?
      @results = Region.order("RANDOM()").limit(20)
    else
      @results = PgSearch.multisearch(params[:query]).where(:searchable_type => "Region").limit(20)
    end
  end

  def render_json
    @results.order(:business, :sub_category, :sid_category, :region)
    hash = @results.each_with_object({"results" => []}) do |result, hsh|
      hsh["results"] << result.searchable.to_search_json
    end
    render :json => hash.to_json
  end
end
