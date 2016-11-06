class StatesController < ApplicationController
  add_breadcrumb "Home", :root_path
  before_action :find_state_and_breadcrumb
  before_action :find_category_and_breadcrumb, except: [:show]

  def show
    @categories = SidCategory.with_businesses.where(businesses: {state: @state})
    @cities = Business.where(state: @state).group_by_city.limit(5)
  end

  def show_state_category
    @sub_categories = @category.sub_categories.roots.left_outer_join_businesses.with_taggings.
                                where(businesses: {state: @state})      
    @cities = Business.where(state: @state, sid_category: @category).group_by_city.limit(5)
  end

  def show_state_category_sub_category
    find_sub_category_and_breadcrumbs
    @sub_categories = @sub_category.children.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id').joins('left outer join businesses on sub_category_taggings.business_id = businesses.id').where("businesses.state = (?)", @state).group('sub_categories.id').order("taggings_count DESC").limit(5)
    @cities = Business.where(state: @state, sid_category: @category).joins(:sub_category_taggings).where("sub_category_taggings.sub_category_id = (?)", @sub_category.id).group_by_city.limit(5)
  end

  private
    def add_sub_category_breadcrumbs
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, state_category_sub_category_path(@state, @category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, state_category_sub_category_path(@state, @category, @sub_category)
    end

    def find_state_and_breadcrumb
      @state = params[:state_code]
      add_breadcrumb @state, state_path(@state)
    end

    def find_category_and_breadcrumb
      @category = SidCategory.find(params[:category_id])
      add_breadcrumb @category.label, state_category_path(@state, @category)
    end

    def find_sub_category_and_breadcrumbs
      @sub_category = SubCategory.find(params[:sub_category_id])
      add_sub_category_breadcrumbs
    end
end
