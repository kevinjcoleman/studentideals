class SearchController < ApplicationController
  def results
    @results = PgSearch.multisearch(params[:query]).with_pg_search_highlight.limit(15)
    render :json => @results.to_json
  end

  def show
  end
end
