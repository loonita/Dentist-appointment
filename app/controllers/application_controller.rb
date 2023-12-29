class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :current_user

  def index;

  end

  def servicios; end

  def ubicacion; end

  def authenticate_admin
    redirect_to root_path, :alert => 'No tienes permisos para realizar esta acción' unless user_is_admin?
  end

  def authenticate_secretary
    redirect_to root_path, :alert => 'No tienes permisos para realizar esta acción' unless user_is_secretary?  || user_is_admin?
  end

  def authenticate_dentist
    redirect_to root_path, :alert => 'No tienes permisos para realizar esta acción' unless user_is_dentist? || user_is_secretary?
  end

  def authenticate_patient
    redirect_to root_path, :alert => 'No tienes permisos para realizar esta acción' unless user_is_patient?
  end

  def protect_pages
    redirect_to new_user_session_path unless current_user
  end

end
