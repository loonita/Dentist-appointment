class ApplicationController < ActionController::Base
  include ApplicationHelper

  def index; end

  def authenticate_admin
    redirect_to root_path, :notice => 'You do not have permission' unless user_is_admin?
  end
end
