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
    if user_is_admin? || user_is_secretary?
      return
    end
    @user = User.find(params[:id])
    if current_user != @user && !user_is_admin? && !user_is_secretary?
      redirect_to root_path, notice: "Lo sentimos, pero sólo puedes ver tu propia página de perfil."
    end
  end

  def edit
    user = User.find(params[:id])


    return if user.nil?
    user_attr_names = []
    user.attributes.each do |el|
      user_attr_names << el[0]
    end

    user_attr_names.each do |attr|
      next if params[:user][attr].nil?

      user[attr] = params[:user][attr]
    end
    respond_to do |format|
      if user.save
        format.html { redirect_to user_path(user), :notice => 'Usuario actualizado con éxito.' }
      else
        format.html { redirect_to user_path(user), :status => :unprocessable_entity }
      end
    end
  end

  def dentists
    @dentists = User.all.filter { |u| u.role_id == 2 }

  end
  def patients
    @patients = User.all.filter { |u| u.role_id == 1 }
  end

  def new
    @user = User.new
  end
  def create
    user = User.new(:name => params[:name], :last_name => params[:last_name], :email => params[:email], :rut => params[:rut], :phone => params[:phone],  :password => params[:password])
    user.save ? (redirect_to root_path, :notice => 'Usuario creado con éxito.') : (redirect_to root_path, :status => :unprocessable_entity)
  end


end




