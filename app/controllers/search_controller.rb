class SearchController < ApplicationController
  def locations
    if params[:query].empty?
      @results = Region.with_businesses.order("RANDOM()").limit(20)
    else
      @results = Region.with_businesses.where("LOWER(name) LIKE LOWER(?)", "%#{params[:query]}%").limit(20)
    end
  end

  def bizcats
    obtain_region_search_results(params[:region], params[:query])
  end

  def redirect
    initialize_redirect_variables
    if @instance && @region
      biz_cat_redirect
    elsif @instance
      biz_cat_redirect
    elsif @region && params[:bizCatTerm].blank?
      region_redirect
    elsif @region && !params[:bizCatTerm].blank?
      redirect_to search_results_path(region: @region.id, bizCatTerm: params[:bizCatTerm])
    elsif !params[:currentLocationValue].blank? && !params[:bizCatTerm].blank?
      redirect_to search_results_path(currentLocationValue: params[:currentLocationValue], bizCatTerm: params[:bizCatTerm])
    elsif !params[:bizCatTerm].blank?
      redirect_to search_results_path(bizCatTerm: params[:bizCatTerm])
    elsif !params[:currentLocationValue].blank?
      redirect_to search_results_path(currentLocationValue: params[:currentLocationValue])
    else
      flash[:danger] = "You must provide a search term!"
      redirect_to root_path
    end
  end

  def results
    if params[:region] && params[:bizCatTerm]
      obtain_region_search_results(params[:region], params[:bizCatTerm])
    elsif params[:currentLocationValue] && params[:bizCatTerm]
      @regions = Region.where("name ~* ?", "#{params[:currentLocationValue]}").limit(20)
      @bizCats = PgSearch.multisearch(params[:bizCatTerm]).where(:searchable_type => ["SubCategory", "SidCategory", "Business"]).reorder(searchable_type: :ASC).limit(20)
    elsif params[:bizCatTerm]
      @bizCats = PgSearch.multisearch(params[:bizCatTerm]).where(:searchable_type => ["SubCategory", "SidCategory", "Business"]).reorder(searchable_type: :ASC).limit(20)
    elsif params[:currentLocationValue]
      @regions = Region.where("name ~* ?", "#{params[:currentLocationValue]}").limit(20)
    end
  end

  def closest_region
    latitude, longitude = params[:lat], params[:lng]
    @region = Region.within(5, :origin => [latitude, longitude]).first
  end

  private
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

    def obtain_region_search_results(region, bizcat)
      @categories = PgSearch.multisearch(bizcat).where(:searchable_type => ["SubCategory", "SidCategory"]).reorder(searchable_type: :ASC).limit(20)
      if region
        @region = Region.find(region)
        @businesses = Business.nearby(@region).where("biz_name ~* ?", "#{bizcat}").limit(5)
      else
        @businesses = Business.where("biz_name ~* ?", "#{bizcat}").limit(5)
      end
    end

    def initialize_redirect_variables
      klass = Object.const_get params[:bizCatType] if params[:bizCatType]
      @instance = klass.find(params[:bizCat]) if params[:bizCat]
      @region = Region.find(params[:location]) if params[:location]
      @biz_cat_term = params[:bizCatTerm] if params[:bizCatTerm]
      @biz_cat_term = params[:bizCatTerm] if params[:bizCatTerm]
    end
end
