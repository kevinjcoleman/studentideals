class CategoriesController < ApplicationController
  add_breadcrumb "Home", :root_path
  respond_to :html, :js

  def show
    @region = Region.find(params[:region_id])
    @category = SidCategory.find(params[:id])
    @businesses_all = @category.businesses.geocoded.within(5, :origin => @region).by_distance(:origin => @region)
    @businesses = @businesses_all.page params[:page]
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @category.label, region_category_path(@region, @category)
    @sub_categories = @category.sub_categories.roots.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins(:sub_category_taggings).where("sub_category_taggings.business_id IN (?)", @businesses_all.pluck(:id)).group('sub_categories.id').order("taggings_count DESC").limit(5)
    return_geojson
  end

  def sub_show
    @region = Region.find(params[:region_id])
    @category = SidCategory.find(params[:category_id])
    @sub_category = SubCategory.find(params[:id])
    @businesses_all = @sub_category.businesses.geocoded.within(5, :origin => @region).by_distance(:origin => @region)
    @businesses = @businesses_all.page params[:page]
    add_breadcrumb @region.name, region_path(@region)
    add_breadcrumb @category.label, region_category_path(@region, @category)
    @sub_categories = @sub_category.children.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins(:sub_category_taggings).where("sub_category_taggings.business_id IN (?)", @businesses_all.pluck(:id)).group('sub_categories.id').order("taggings_count DESC").limit(5)
    add_sub_category_breadcrumbs_show
    return_geojson
  end

  def list
    @category = SidCategory.find(params[:id])
    add_breadcrumb @category.label, businesses_for_category_path(@category)
    @states = Business.where("state IS NOT NULL AND sid_category_id = (?)", @category.id).group("state").select("state, count(id) as count").order("count DESC").limit(5)
    @sub_categories = @category.sub_categories.roots.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id').group('sub_categories.id').order("taggings_count DESC").limit(5)
  end

  def sub_list
    @category = SidCategory.find(params[:category_id])
    add_breadcrumb @category.label, businesses_for_category_path(@category)
    @sub_category = SubCategory.find(params[:id])
    @states = Business.where("state IS NOT NULL AND sid_category_id = (?)", @category.id).joins(:sub_category_taggings).where("sub_category_taggings.sub_category_id = (?)", @sub_category.id).group("state").select("state, count(businesses.id) as count").order("count DESC").limit(5)
    add_sub_category_breadcrumbs_list
    @children = @sub_category.children.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id').group('sub_categories.id').order("taggings_count DESC").limit(5)
  end

  private

    def return_geojson
      respond_to do |format|                          
        format.json { render json: [@region.geojsonify(color: "blue")] + @businesses.map {|b| b.geojsonify(color: "orange")}}  # respond with the created JSON object
        format.html
      end
    end

    def add_sub_category_breadcrumbs_show
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, businesses_for_category_region_and_subcategory_path(@region, @category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, businesses_for_category_region_and_subcategory_path(@region, @category, @sub_category)
    end

    def add_sub_category_breadcrumbs_list
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, businesses_for_category_and_subcategory_path(@category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, businesses_for_category_and_subcategory_path(@category, @sub_category)
    end
end