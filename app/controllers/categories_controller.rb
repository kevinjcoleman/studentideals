class CategoriesController < ApplicationController
  add_breadcrumb "Home", :root_path
  respond_to :html, :js

  def show
    find_region_and_category_and_breadcrumbs(params[:region_id], params[:id])
    @businesses_all = @category.businesses.nearby(@region)
    @businesses = @businesses_all.page params[:page]
    @sub_categories = @category.sub_categories.roots.
                                join_and_order_by_taggings_count.
                                where(sub_category_taggings: {business_id: @businesses_all.pluck(:id)}).
                                limit(5)
    return_geojson
  end

  def sub_show
    find_region_and_category_and_breadcrumbs(params[:region_id], params[:category_id])
    @sub_category = SubCategory.find(params[:id])
    @businesses_all = @sub_category.businesses.nearby(@region)
    @businesses = @businesses_all.page params[:page]
    @sub_categories = @sub_category.children.
                                    join_and_order_by_taggings_count.
                                    where(sub_category_taggings: {business_id: @businesses_all.pluck(:id)}).
                                    limit(5)
    add_sub_category_breadcrumbs_show
    return_geojson
  end

  def list
    find_category_and_breadcrumb(params[:id])
    @states = Business.group_by_state.
                       where(sid_category_id: @category.id).
                       limit(5)
    @sub_categories = @category.sub_categories.
                                roots.
                                join_and_order_by_taggings_count.
                                limit(5)
  end

  def sub_list
    find_category_and_breadcrumb(params[:category_id])
    @sub_category = SubCategory.find(params[:id])
    @states = @sub_category.businesses.
                            group_by_state.
                            limit(5)
    add_sub_category_breadcrumbs_list
    @children = @sub_category.children.
                              join_and_order_by_taggings_count.
                              limit(5)
  end

  private

    def find_category_and_breadcrumb(category_id)
      @category = SidCategory.find(category_id)
      add_breadcrumb @category.label, category_path(@category)
    end

    def find_region_and_category_and_breadcrumbs(region_id, category_id)
      @region = Region.find(region_id)
      @category = SidCategory.find(category_id)
      add_breadcrumb @region.name, region_path(@region)
      add_breadcrumb @category.label, region_and_category_path(@region, @category)
    end


    def return_geojson
      respond_to do |format|
        format.json { render json: [@region.geojsonify(color: "blue")] + @businesses.map {|b| b.geojsonify(color: "orange")}}  # respond with the created JSON object
        format.html
      end
    end

    def add_sub_category_breadcrumbs_show
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, region_category_and_subcategory_path(@region, @category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, region_category_and_subcategory_path(@region, @category, @sub_category)
    end

    def add_sub_category_breadcrumbs_list
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, category_and_subcategory_path(@category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, category_and_subcategory_path(@category, @sub_category)
    end
end
