class SearchController < ApplicationController
  def results
    @results = PgSearch.multisearch(params[:query])
    render_json
  end

  def render_json
    @results.order(:business, :sub_category, :sid_category, :region)
    hash = @results.each_with_object({"results" => []}) do |result, hsh|
      if result.searchable_type == "Business"
        business = result.searchable
        hsh["results"] = hsh["results"] + [{label: business.biz_name, 
                searchable_type: "Business",
                id: business.slug,
                url: "/region/#{business.region.slug}/businesses/#{business.slug}"} ]
      elsif result.searchable_type == "Region"
        region = result.searchable
        hsh["results"] = hsh["results"] + [{label: region.name, 
                searchable_type: "Locale",
                id: region.slug,
                url: "/region/#{region.slug}"} ]
      elsif result.searchable_type == "SidCategory"
        category = result.searchable
        hsh["results"] = hsh["results"] + [{label: category.label, 
                searchable_type: "SID Category",
                id: category.slug,
                url: "/category/#{category.slug}"} ]
      elsif result.searchable_type == "SubCategory"
        category = result.searchable
        hsh["results"] = hsh["results"] + [{label: category.label, 
                searchable_type: "Category",
                id: category.slug,
                url: "/category/#{category.sid_category.slug}/sub_category/#{category.slug}"} ]
      end
    end
    render :json => hash.to_json
  end
end
