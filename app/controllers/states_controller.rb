class StatesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @state = params[:state_code]
    add_breadcrumb @state, state_path(@state)
    @businesses = Business.where(state: @state).count
    @categories = SidCategory.select('sid_categories.*, count(businesses.id) as business_count').joins('left outer join businesses on businesses.sid_category_id = sid_categories.id').where("businesses.state = ?", @state).group('sid_categories.id').order("business_count DESC")
    @cities = Business.where(state: @state).group("city").select("city, count(id) as count").order("count DESC").limit(5)
  end

  def show_state_category
    @state = params[:state_code]
    @category = SidCategory.find(params[:category_id])
    add_breadcrumb @state, state_path(@state)
    add_breadcrumb @category.label, state_category_path(@state, @category)
    @sub_categories = @category.sub_categories.roots.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id').joins('left outer join businesses on sub_category_taggings.business_id = businesses.id').where("businesses.state = (?)", @state).group('sub_categories.id').order("taggings_count DESC").limit(5)
    @businesses = Business.where(state: @state, sid_category: @category).count
    @cities = Business.where(state: @state, sid_category: @category).group("city").select("city, count(id) as count").order("count DESC").limit(5)
  end

  def show_state_category_sub_category
    @state = params[:state_code]
    @category = SidCategory.find(params[:category_id])
    @sub_category = SubCategory.find(params[:sub_category_id])
    add_breadcrumb @state, state_path(@state)
    add_breadcrumb @category.label, state_category_path(@state, @category)
    add_sub_category_breadcrumbs_list
    @sub_categories = @sub_category.children.select('sub_categories.*, count(sub_category_taggings.id) as taggings_count').joins('left outer join sub_category_taggings on sub_category_taggings.sub_category_id = sub_categories.id').joins('left outer join businesses on sub_category_taggings.business_id = businesses.id').where("businesses.state = (?)", @state).group('sub_categories.id').order("taggings_count DESC").limit(5)
    @businesses = Business.where(state: @state, sid_category: @category).joins(:sub_category_taggings).where("sub_category_taggings.sub_category_id = (?)", @sub_category.id).count
    @cities = Business.where(state: @state, sid_category: @category).joins(:sub_category_taggings).where("sub_category_taggings.sub_category_id = (?)", @sub_category.id).group("city").select("city, count(businesses.id) as count").order("count DESC").limit(5)
  end

  private
    def add_sub_category_breadcrumbs_list
      if @sub_category.ancestors.any?
        @sub_category.ancestors.each do |ancestor|
          add_breadcrumb ancestor.label, state_category_sub_category_path(@state, @category, ancestor)
        end
      end
      add_breadcrumb @sub_category.label, state_category_sub_category_path(@state, @category, @sub_category)
    end
end
