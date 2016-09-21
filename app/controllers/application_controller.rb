class ApplicationController < ActionController::Base
  before_action :find_categories_for_nav
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def find_categories_for_nav
    @nav_categories = SidCategory.all
  end
end
