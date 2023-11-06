class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_see_own_page, only: [:show]
  def show
    @user = User.find(params[:id])
    @appointments = Appointment.all.filter { |a| a.user_id == @user.id }
    @user_from_appointments = Appointment.find(params[:id])

  end
  def only_see_own_page
    @user = User.find(params[:id])

    if current_user != @user
      redirect_to root_path, notice: "Lo sentimos, pero sólo puedes ver tu propia página de perfil."
    end
  end
end
