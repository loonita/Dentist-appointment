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
    if user_is_secretary?
      @appointments = Appointment.all
    end
    if user_is_patient?
      @appointments = Appointment.all.filter { |a| a.user_id == current_user.id }
    end
    if user_is_dentist?
      @appointments = Appointment.all.filter { |a| a.dentist_id == current_user.id }
    end
    if params[:search].present?
      @appointments = @appointments.filter { |a| a.user_id.eql?(params[:search].to_i) }
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

  end

  def agendar_d
    @fecha_recibida = params[:fecha_t]
    @dentist_recibido = params[:dentist_t]

    if user_is_patient?
      @dentists = User.all.filter { |u| u.role_id == 2 }
    end
  end
  def agendar_en_espera
    @appointment = Appointment.new
    @all_appointments = Appointment.all
  end

  def agendar_espera
    return if params[:appointment].nil?

    user_id = params[:appointment][:user_id].to_i
    dentist_id = params[:appointment][:dentist_id].to_i
    status_id = params[:appointment][:status].to_i

    appointment = Appointment.new(:user_id => user_id, :dentist_id => dentist_id, :status_id => status_id)

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
    @appointment = Appointment.find(params[:id])
  end

  def only_see_own_appointment
    @appointment = Appointment.find(params[:id])
    if current_user != @appointment.user && !user_is_admin? && !user_is_dentist? && !user_is_secretary?
      redirect_to root_path, notice: "Sorry, but you are only allowed to view your own appointments."
    end
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    @all_appointments = Appointment.all

    @fecha_recibida = params[:fecha_t]

    if user_is_admin? || user_is_secretary? || user_is_patient?
      @dentist_recibido = params[:dentist_t]
      @dentist_name = "Dra. " + User.find_by(id: @dentist_recibido).name + " " + User.find_by(id: @dentist_recibido).last_name
      @horas_agendadas = Appointment.where(start_time: @fecha_recibida, dentist_id: @dentist_recibido, status_id: 1).pluck(:time)
      @horas_confirmadas = Appointment.where(start_time: @fecha_recibida, dentist_id: @dentist_recibido, status_id: 2).pluck(:time)
    end

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

    sum_start_time_and_time

  end

  def sum_start_time_and_time
    # Unir start_time y time para que se muestren en orden las citas en el calendario.
    if @appointment.start_time && @appointment.time
      new_start_time = @appointment.start_time + @appointment.time.seconds_since_midnight.seconds

      @appointment.start_time = new_start_time
    end
  end

  # GET /appointments/1/edit
  def edit
  end
  def pending
    if user_is_admin? || user_is_secretary? || user_is_dentist?
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
    params.require(:appointment).permit(:start_time, :time, :status_id, :user_id, :dentist_id)
  end
end
