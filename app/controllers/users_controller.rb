class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @appointments = Appointment.all.filter { |a| a.user_id == @user.id }
    @user_from_appointments = Appointment.find(params[:id])

  end

end
