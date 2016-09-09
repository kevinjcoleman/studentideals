class StatesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @state = params[:state_code]
    add_breadcrumb @state, state_path(@state)
    @businesses = Business.where(state: @state).count
    @categories = SidCategory.select('sid_categories.*, count(businesses.id) as business_count').joins('left outer join businesses on businesses.sid_category_id = sid_categories.id').where("businesses.state = ?", @state).group('sid_categories.id').order("business_count DESC")
    @cities = Business.where(state: @state).group("city").select("city, count(id) as count").order("count DESC").limit(5)
  end
end
