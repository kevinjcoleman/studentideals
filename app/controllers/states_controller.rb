class StatesController < ApplicationController
  add_breadcrumb "Home", :root_path
  before_action :find_state_and_breadcrumb
  before_action :find_category_and_breadcrumb, except: [:show]

  def show
    @categories = SidCategory.with_businesses.where(businesses: {state: @state}).limit(5)
    @cities = Business.group_by_city.where(state: @state).limit(5)
  end

  def show_state_and_category
    @sub_categories = @category.sub_categories.roots.
                                left_outer_join_businesses.
                                with_taggings.
                                where(businesses: {state: @state}).limit(5)
    @cities = @category.businesses.group_by_city.
                       where(state: @state).
                       limit(5)
  end

  def show_state_category_and_subcategory
    find_sub_category_and_breadcrumbs
    @sub_categories = @sub_category.children.
                                    left_outer_join_businesses.
                                    with_taggings.
                                    where(businesses: {state: @state}).limit(5)
    @cities = @sub_category.businesses.group_by_city.
                       where(state: @state).
                       limit(5)
  end

  private
    def add_sub_category_breadcrumbs
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, state_category_and_subcategory_path(@state, @category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, state_category_and_subcategory_path(@state, @category, @sub_category)
    end

    def find_state_and_breadcrumb
      @state = params[:state_code]
      add_breadcrumb @state, state_path(@state)
    end

    def find_category_and_breadcrumb
      @category = SidCategory.find(params[:category_id])
      add_breadcrumb @category.label, state_and_category_path(@state, @category)
    end

    def find_sub_category_and_breadcrumbs
      @sub_category = SubCategory.find(params[:sub_category_id])
      add_sub_category_breadcrumbs
    end
end
