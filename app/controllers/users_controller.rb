class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_see_own_page, only: [:show]

  def show
    @user = User.find(params[:id])
    @appointments = []
    if user_is_patient?(@user)
      @appointments = Appointment.all.filter { |a| a.user_id == @user.id }
    end
    if user_is_dentist?(@user)
      @appointments = Appointment.all.filter { |a| a.dentist_id == @user.id }
    end
    @user_from_users = User.find(params[:id])
  end

  def only_see_own_page
    if user_is_admin? || user_is_dentist? || user_is_secretary?
      return
    end
    @user = User.find(params[:id])
    if current_user != @user && !user_is_admin? && !user_is_dentist? && !user_is_secretary?
      redirect_to root_path, notice: "Lo sentimos, pero sólo puedes ver tu propia página de perfil."
    end
  end

  def edit
    @user = User.find(params[:id])
    if current_user != @user
      redirect_to root_path, notice: "Lo sentimos, pero sólo puedes editar tu propia página de perfil."
    end
  end

  def dentists
    @dentists = User.all.filter { |u| u.role_id == 2 }

  end
  def patients
    @patients = User.all.filter { |u| u.role_id == 1 }
  end
end
