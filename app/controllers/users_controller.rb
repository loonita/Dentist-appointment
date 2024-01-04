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
      @appointments = Appointment.where(user_id: @user.id, status_id: [1,2]).order(:start_time).page(params[:page]).per(5)
    end
    if user_is_dentist?(@user)
      @appointments = Appointment.where(dentist_id: @user.id, status_id: [1,2]).order(:start_time).page(params[:page]).per(5)
    end
    @user_from_users = User.find(params[:id])
  end

  def only_see_own_page
    if user_is_admin? || user_is_secretary?
      return
    end
    @user = User.find(params[:id])
    if current_user != @user && !user_is_admin? && !user_is_secretary?
      redirect_to root_path, notice: "Lo sentimos, solo puedes ver tu propio perfil."
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
    if user_is_patient? || user_is_inactive?
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end

    if params[:search].present?
      @dentists = User.where(role_id: 2).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(10)
    else
      @dentists = User.where(role_id: 2).order(:last_name).page(params[:page]).per(10)
    end
  end

  def patients
    if user_is_patient? || user_is_inactive?
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end

    if params[:search].present?
      @patients = User.where(role_id: 1).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(10)
    else
      @patients = User.where(role_id: 1).order(:last_name).page(params[:page]).per(10)
    end
  end

  def secretaries
    if user_is_admin?
      @secretaries = User.where(role_id: 3).order(:last_name).page(params[:page]).per(10)
    else
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end
  end

  def inactivos
    if user_is_admin?
      if params[:search].present?
        @inactivos = User.where(role_id: 5).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(10)
      else
        @inactivos = User.where(role_id: 5).order(:last_name).page(params[:page]).per(10)
      end
    else
      redirect_to root_path, notice: "Lo sentimos, no puedes ver esta página."
    end
  end

  def new
    if user_is_admin? || user_is_secretary?
      @user = User.new
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes realizar esta acción."
    end
  end
  def create
    if user_is_admin? || user_is_secretary?
      @user = User.new(user_params)

      if @user.save
        redirect_to root_path, :notice => 'Usuario creado con éxito.'
      else
        render 'new', :alert => 'No se pudo crear el usuario.'
      end
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes realizar esta acción."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :last_name, :email, :rut, :phone, :password)
  end

end




