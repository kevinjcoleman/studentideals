class ApplicationController < ActionController::Base
  before_action :find_defaults_for_nav
  before_action :init_signup
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def find_defaults_for_nav
    @nav_categories = SidCategory.all
    @nav_cities = Business.group("city, state").select("city, state, count(id) as count").order("count DESC").limit(5)
  end

  def splashed?
    cookies[:splashed]
  end
  helper_method :splashed?

  def init_signup
    @signup = Signup.new unless splashed?
  end
end
