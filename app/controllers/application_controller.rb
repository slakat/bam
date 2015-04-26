class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  load_and_authorize_resource
  protect_from_forgery with: :exception
end
