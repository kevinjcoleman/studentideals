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

  def bizcats
    @categories = PgSearch.multisearch(params[:query]).where(:searchable_type => ["SubCategory", "SidCategory"]).reorder(searchable_type: :ASC).limit(20)
    if params[:region]
      region = Region.find(params[:region])
      @businesses = Business.nearby(region).where("biz_name ~* ?", "#{params[:query]}").limit(5)
    else
      @businesses = Business.where("biz_name ~* ?", "#{params[:query]}").limit(5)
    end
  end

  def redirect
    klass = Object.const_get params[:bizCatType]
    instance = klass.find(params[:bizCat])
    @region = Region.find(params[:location]) if params[:location]
    if instance.is_a?(Business)
      business_redirect(instance, @region)
    elsif instance.is_a?(SidCategory)
      sid_cat_redirect(instance, @region)
    else
      sub_cat_redirect(instance, @region)
    end
  end

  def business_redirect(business, region)
    if region
      redirect_to region_business_path(region, business)
    else
      redirect_to region_business_path(business.region, business)
    end
  end

  def sid_cat_redirect(sid_cat, region)
    if region
      redirect_to region_and_category_path(region, sid_cat)
    else
      redirect_to category_path(sid_cat)
    end
  end

  def sub_cat_redirect(sub_cat, region)
    if region
      redirect_to region_category_and_subcategory_path(region, sub_cat.sid_category, sub_cat)
    else
      redirect_to category_and_subcategory_path(sub_cat.sid_category, sub_cat)
    end
  end
end
