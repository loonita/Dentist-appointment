class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_see_own_page, only: [:show]


  def index
    if params[:search].present?
      @users = Users.search_by_patient_name(params[:search]).order(:last_name)
    else
      @users = Users.all.order(:last_name)
    end
  end

  def show
    @user = User.find(params[:id])
    @appointments = []
    if user_is_patient?(@user)
      @appointments = Appointment.where(user_id: @user.id).order(:start_time)
    end
    if user_is_dentist?(@user)
      @appointments = Appointment.where(dentist_id: @user.id).order(:start_time)
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

  def index
    if params[:search].present?
      @patients = User.search_by_patient_name(params[:search]).order(:last_name)
    else
      @patients = User.where(role_id: 1).order(:last_name)
    end


  end

  def dentists
    if user_is_patient?
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end

    if params[:search].present?
      @dentists = User.where(role_id: 2).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(5)
    else
      @dentists = User.where(role_id: 2).order(:last_name).page(params[:page]).per(5)
    end
  end

  def patients
    if user_is_patient?
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end

    if params[:search].present?
      @patients = User.where(role_id: 1).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(5)
    else
      @patients = User.where(role_id: 1).order(:last_name).page(params[:page]).per(5)
    end
  end

  def new
    @user = User.new
  end
  def create
    user = User.new(:name => params[:name], :last_name => params[:last_name], :email => params[:email], :rut => params[:rut], :phone => params[:phone],  :password => params[:password])
    user.save ? (redirect_to root_path, :notice => 'Usuario creado con éxito.') : (redirect_to root_path, :status => :unprocessable_entity)
  end



end




