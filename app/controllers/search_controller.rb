class SearchController < ApplicationController
  def locations
    if params[:query].empty?
      @results = Region.order("RANDOM()").limit(20)
    else
      @results = PgSearch.multisearch(params[:query]).where(:searchable_type => "Region").limit(20)
    end
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
    klass = Object.const_get params[:bizCatType] if params[:bizCatType]
    @instance = klass.find(params[:bizCat]) if params[:bizCat]
    @region = Region.find(params[:location]) if params[:location]
    @biz_cat_term = params[:bizCatTerm] if params[:bizCatTerm]
    @biz_cat_term = params[:bizCatTerm] if params[:bizCatTerm]
    if @instance && @region
      biz_cat_redirect
    elsif @instance
      biz_cat_redirect
    elsif @region && params[:bizCatTerm].blank?
      region_redirect
    else
      flash.now[:danger] = "You must provide a search term!"
      redirect_to root_path
    end
  end

  def business_redirect(business)
      redirect_to business_path(business)
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

  def region_redirect
    redirect_to region_path(@region)
  end

  def biz_cat_redirect
    if @instance.is_a?(Business)
      business_redirect(@instance)
    elsif @instance.is_a?(SidCategory)
      sid_cat_redirect(@instance, @region)
    else
      sub_cat_redirect(@instance, @region)
    end
  end
end
