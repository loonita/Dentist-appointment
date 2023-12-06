class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :authenticate_admin, only: %i[  edit destroy ]
  before_action :only_see_own_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments or /appointments.json
  def index
    if user_is_admin?
      @appointments = Appointment.all
    end
    if user_is_patient?
      @appointments = Appointment.all.filter { |a| a.user_id == current_user.id }
    end
    if user_is_dentist?
      @appointments = Appointment.all.filter { |a| a.dentist_id == current_user.id }
    end


  end

  # GET /appointments/1 or /appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])
  end

  def only_see_own_appointment
    @appointment = Appointment.find(params[:id])
    if current_user != @appointment.user && !user_is_admin?
      redirect_to root_path, notice: "Sorry, but you are only allowed to view your own appointments."
    end
    end
  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end
  def pending
    if user_is_admin?
    @appointments = Appointment.all.filter { |a| a.status_id == 5 }

    else
      redirect_to root_path, notice: "Lo sentimos, pero sólo puedes ver tus propias citas."
    end
  end


# POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to appointment_url(@appointment), notice: "La cita fue creada exitoamente." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "La cita se ha actualizado correctamente." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy!

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "La cita fue destruida correctamente." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:date, :time, :status_id, :user_id, :dentist_id)
  end
end
