class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :store_location

  def store_location
    session[:account_return_to] = request.url unless params[:controller] == "devise/sessions"
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
