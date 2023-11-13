class ApplicationController < ActionController::Base
  include ApplicationHelper

  def index; end

  def authenticate_admin
    redirect_to root_path, :notice => 'No tienes permisos para realizar esta acción' unless user_is_admin?
  end

  def authenticate_secretary
    redirect_to root_path, :notice => 'No tienes permisos para realizar esta acción' unless user_is_secretary?
  end

  def authenticate_dentist
    redirect_to root_path, :notice => 'No tienes permisos para realizar esta acción' unless user_is_dentist?
  end

  def authenticate_patient
    redirect_to root_path, :notice => 'No tienes permisos para realizar esta acción' unless user_is_patient?
  end
end
