class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :only_see_own_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments or /appointments.json
  def index

    if user_is_admin? || user_is_secretary?
        @appointments = Appointment.all.order(:start_time).page(params[:page]).per(10)

      if params[:search].present?
        @appointments = Appointment.search_by_patient_name(params[:search]).order(:start_time).page(params[:page]).per(10)
      else
        @appointments = Appointment.all.order(:start_time).page(params[:page]).per(10)
      end
    end

    if user_is_patient?
      @appointments = Appointment.where(user_id: current_user.id).order(:start_time).page(params[:page]).per(10)
    end

    if user_is_dentist?
      if params[:search].present?
        @appointments = Appointment.where(dentist_id: current_user.id).search_by_patient_name(params[:search]).order(:start_time).page(params[:page]).per(10)
      else
        @appointments = Appointment.where(dentist_id: current_user.id).order(:start_time).page(params[:page]).per(10)
      end
    end
  end

  def calendar
    @appointments = Appointment.where(
      start_time: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week
    )

    if user_is_patient?
      @appointments = Appointment.all.filter { |a| a.user_id == current_user.id }
    end
    if user_is_dentist?
      @appointments = Appointment.all.filter { |a| a.dentist_id == current_user.id }
    end
    if params[:search].present?
      @appointments = @appointments.filter { |a| a.user_id.eql?(params[:search].to_i) }
    end

    if user_is_admin? || user_is_secretary?
      @users = User.all.filter { |u| u.role_id == 2 }
    end

  end

  def agendar
    if !user_is_patient?
      redirect_to root_path
    end
  end

  def agendar_d

    if !user_is_patient?
      redirect_to root_path
    end

    @fecha_recibida = params[:fecha_t]
    @dentist_recibido = params[:dentist_t]

    if user_is_patient?
      @dentists = User.all.filter { |u| u.role_id == 2 }
    end
  end

  def agendar_p
    if user_is_dentist? || user_is_patient?
      redirect_to root_path
    end

    if params[:search].present?
      @patients = User.where(role_id: 1).search_by_name(params[:search]).order(:last_name)
    else
      @patients = User.where(role_id: 1).order(:last_name)
    end

    @fecha_recibida = params[:fecha_t]
    @dentist_recibido = params[:dentist_t]
  end

  def agendar_en_espera
    if user_is_dentist? || user_is_patient?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end

    @appointment = Appointment.new
    @all_appointments = Appointment.all
  end

  def agendar_espera
    if user_is_dentist? || user_is_patient?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end

    return if params[:appointment].nil?

    user_id = params[:appointment][:user_id].to_i
    dentist_id = params[:appointment][:dentist_id].to_i
    status_id = params[:appointment][:status].to_i
    urgencia_id = params[:appointment][:urgencia_id].to_i
    mensaje = params[:appointment][:mensaje]

    appointment = Appointment.new(:user_id => user_id, :dentist_id => dentist_id, :status_id => status_id, :urgencia_id => urgencia_id, :mensaje => mensaje)

    respond_to do |format|
      if appointment.save!
        format.html { redirect_to appointment_path(appointment), :notice => 'Cita en lista de espera creada exitosamente!' }
      else
        format.html { redirect_to espera_path, :status => :unprocessable_entity }
      end
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  def only_see_own_appointment
    @appointment = Appointment.find(params[:id])
    if current_user != @appointment.user && !user_is_admin? && !user_is_dentist? && !user_is_secretary?
      redirect_to root_path, notice: "Lo sentimos, solo puedes ver tus propias citas."
    end
  end

  # GET /appointments/new
  def new

    if user_is_dentist?
      redirect_to root_path
    end

    @appointment = Appointment.new
    @all_appointments = Appointment.all

    @fecha_recibida = params[:fecha_t]

    if user_is_admin? || user_is_secretary?
      @patient_recibido = params[:patient_t]
      @patient_name = User.find_by(id: @patient_recibido).name + " " + User.find_by(id: @patient_recibido).last_name
      @patient_rut = User.find_by(id: @patient_recibido).rut
    end

    @dentist_recibido = params[:dentist_t]
    @dentist_name = "Dra. " + User.find_by(id: @dentist_recibido).name + " " + User.find_by(id: @dentist_recibido).last_name

    @horas_agendadas = Appointment.where("DATE(start_time) = ? AND dentist_id = ? AND status_id = ?", @fecha_recibida, @dentist_recibido, 1).pluck(:time)
    @horas_confirmadas = Appointment.where("DATE(start_time) = ? AND dentist_id = ? AND status_id = ?", @fecha_recibida, @dentist_recibido, 2).pluck(:time)

    @horas_ocupadas_A = []
    @horas_ocupadas_C = []

    @horas_agendadas.each do |a|
      appo = Appointment.find_by(time: a)
      if appo
        @test = appo.hora.to_s
        @horas_ocupadas_A << @test
      end
    end

    @horas_confirmadas.each do |a|
      appo = Appointment.find_by(time: a)
      if appo
        @test = appo.hora.to_s
        @horas_ocupadas_C << @test
      end
    end

    @horas_disponibles = []
    @todo = MorningTime.all

    @todo.each do |m|
      @horas_disponibles << m.m_time
    end

    @horas_disponibles = @horas_disponibles - @horas_ocupadas_A - @horas_ocupadas_C

  end

  # GET /appointments/1/edit
  def edit
    if user_is_dentist?
      redirect_to appointments_path, alert: "Lo sentimos, no puedes ver esto."
    end
    if user_is_patient? && @appointment.status_id != 1
      redirect_to appointments_path, alert: "Lo sentimos, no puedes ver esto."
    end
    if user_is_patient? && @appointment.start_time > Time.now + 3.day
      redirect_to appointments_path, alert: "Lo sentimos, no puedes ver esto."
    end
    if user_is_secretary? || user_is_admin? && @appointment.start_time < Time.now - 1.day
      redirect_to calendar_path, alert: "Lo sentimos, el estado de esta cita ya no se puede cambiar."
    end
  end
  def pending
    if user_is_admin? || user_is_secretary? || user_is_dentist?
      if params[:search].present?
        @appointments = Appointment.where(status_id: 5).search_by_patient_name(params[:search]).page(params[:page]).per(10)
      else
        @appointments = Appointment.where(status_id: 5).page(params[:page]).per(10)
      end
    else
      redirect_to root_path, alert: "Lo sentimos, pero sólo puedes ver tus propias citas."
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
    params.require(:appointment).permit(:start_time, :time, :status_id, :user_id, :dentist_id)
  end
end

