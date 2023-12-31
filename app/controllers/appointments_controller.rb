class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :only_see_own_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments or /appointments.json
  def index
    if user_is_admin? || user_is_secretary? || user_is_dentist? || user_is_patient?
      appointments = Appointment.where.not(status_id: [3, 4, 5])

      if params[:status_id].present? || params[:search].present? || params[:start_date].present? || params[:end_date].present?
        if user_is_admin? || user_is_secretary?
          appointments = appointments.where(status_id: params[:status_id]) if params[:status_id].present?
          appointments = appointments.search_by_patient_name(params[:search]) if params[:search].present?
        elsif user_is_patient?
          appointments = Appointment.where.not(status_id: 5)
          appointments = appointments.where(user_id: current_user.id)
          if params[:status_id] == '8'
            appointments = appointments.where(status_id: [1, 2].map(&:to_i))
          else
          appointments = appointments.where(status_id: params[:status_id]) if params[:status_id].present?
          end

        elsif user_is_dentist?
          appointments = appointments.where(dentist_id: current_user.id)
          appointments = appointments.where(status_id: params[:status_id]) if params[:status_id].present?
          appointments = appointments.search_by_patient_name(params[:search]) if params[:search].present?
        end

        if params[:start_date].present? && params[:end_date].present?
          start_date = params[:start_date]
          end_date = params[:end_date] + ' 23:59:59'
          appointments = appointments.where("start_time >= ? AND start_time <= ?", start_date, end_date)
        elsif params[:start_date].present?
          start_date = DateTime.parse(params[:start_date])
          appointments = appointments.where('start_time >= ?', start_date)
        elsif params[:end_date].present?
          end_date = DateTime.parse(params[:end_date])
          appointments = appointments.where('start_time <= ?', end_date)
        end

        @appointments = appointments.order(:start_time).page(params[:page]).per(10)
      else
        if user_is_admin? || user_is_secretary?
        @appointments = appointments.where.not(status_id: [3, 4, 5]).order(:start_time).page(params[:page]).per(10)
        elsif user_is_patient?
          @appointments = Appointment.where.not(status_id: 5).where(user_id: current_user.id).order(:start_time).page(params[:page]).per(10)
        elsif user_is_dentist?
          @appointments = appointments.where.not(status_id: [3, 4, 5]).where(dentist_id: current_user.id).order(:start_time).page(params[:page]).per(10)
        end
      end

    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def calendar

    if user_is_admin? || user_is_secretary? || user_is_dentist? || user_is_patient?
      if params[:start_date].present?
        if params[:start_date] == 'start_date='
          params[:start_date] = Date.today.strftime("%Y-%m-%d")
        else
          params[:start_date] += '-01'
        end
      else
        params[:start_date] = Date.today.strftime("%Y-%m-%d")
      end

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
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def agendar
    if !user_is_patient?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def agendar_d
    if !user_is_patient?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end

    @fecha_recibida = params[:fecha_t]
    @dentist_recibido = params[:dentist_t]

    if user_is_patient?
      @dentists = User.all.filter { |u| u.role_id == 2 }
    end
  end

  def agendar_p
    if user_is_admin? || user_is_secretary?

      if params[:search].present?
        @patients = User.where(role_id: 1).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(10)
      else
        @patients = User.where(role_id: 1).order(:last_name).page(params[:page]).per(10)
      end

      @fecha_recibida = params[:fecha_t]
      @dentist_recibido = params[:dentist_t]

    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def espera_paciente
    if user_is_admin? || user_is_secretary?
      if params[:search].present?
        @patients = User.where(role_id: 1).search_by_name(params[:search]).order(:last_name).page(params[:page]).per(10)
      else
        @patients = User.where(role_id: 1).order(:last_name).page(params[:page]).per(10)
      end
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def agendar_en_espera
    if user_is_admin? || user_is_secretary?
      @appointment = Appointment.new
      @all_appointments = Appointment.all
      @patient_recibido = params[:patient_t]
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def agendar_espera
    if user_is_admin? || user_is_secretary?
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
    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    if user_is_inactive?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def only_see_own_appointment
    @appointment = Appointment.find(params[:id])
    if current_user != @appointment.user && !user_is_admin? && !user_is_dentist? && !user_is_secretary?
      redirect_to root_path, notice: "Lo sentimos, solo puedes ver tus propias citas."
    end
  end

  # GET /appointments/new
  def new

    if user_is_dentist? || user_is_inactive?
      redirect_to root_path, alert: "Lo sentimos, no puedes realizar esta acción."
    end

    @appointment = Appointment.new
    @all_appointments = Appointment.all

    @fecha_recibida = params[:fecha_t]

    if user_is_admin? || user_is_secretary?
      @patient_recibido = params[:patient_t]
    end

    @dentist_recibido = params[:dentist_t]

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
    if user_is_dentist? || user_is_inactive?
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

    if user_is_admin? || user_is_secretary?
      appointments = Appointment.where(status_id: 5).order(urgencia_id: :desc)

      if params[:urgencia_id].present? || params[:search].present? || params[:start_date].present? || params[:end_date].present?

          appointments = appointments.where(urgencia_id: params[:urgencia_id]) if params[:urgencia_id].present?
          appointments = appointments.search_by_patient_name(params[:search]) if params[:search].present?

        if params[:start_date].present? && params[:end_date].present?
          start_date = params[:start_date]
          end_date = params[:end_date] + ' 23:59:59'
          appointments = appointments.where("created_at >= ? AND created_at <= ?", start_date, end_date)
        elsif params[:start_date].present?
          start_date = DateTime.parse(params[:start_date])
          appointments = appointments.where('created_at >= ?', start_date)
        elsif params[:end_date].present?
          end_date = DateTime.parse(params[:end_date])
          appointments = appointments.where('created_at <= ?', end_date)
        end

        @appointments = appointments.order(:created_at).page(params[:page]).per(10)
      else
          @appointments = appointments.where(status_id: 5).order(urgencia_id: :desc).order(:created_at).page(params[:page]).per(10)
      end

    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def inactive
    if user_is_admin? || user_is_secretary?
      appointments = Appointment.where.not(status_id: [1, 2, 5])

      if params[:status_id].present? || params[:search].present? || params[:start_date].present? || params[:end_date].present?

          appointments = appointments.where(status_id: params[:status_id]) if params[:status_id].present?
          appointments = appointments.search_by_patient_name(params[:search]) if params[:search].present?

        if params[:start_date].present? && params[:end_date].present?
          start_date = params[:start_date]
          end_date = params[:end_date] + ' 23:59:59'
          appointments = appointments.where("start_time >= ? AND start_time <= ?", start_date, end_date)
        elsif params[:start_date].present?
          start_date = DateTime.parse(params[:start_date])
          appointments = appointments.where('start_time >= ?', start_date)
        elsif params[:end_date].present?
          end_date = DateTime.parse(params[:end_date])
          appointments = appointments.where('start_time <= ?', end_date)
        end

        @appointments = appointments.order(:start_time).page(params[:page]).per(10)
      else
          @appointments = appointments.where.not(status_id: [1, 2, 5]).order(:start_time).page(params[:page]).per(10)
      end

    else
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
  end

  def edit_p_dum
    if user_is_dentist? || user_is_patient? || user_is_inactive?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
    @id_ap = params[:id_ap]
    if Appointment.find(@id_ap).status_id == 5
      @appointment = Appointment.find(@id_ap)
    else
      redirect_to root_path, alert: "Lo sentimos, esta cita no se puede editar."
    end
  end

  def edit_p_calendar
    if user_is_dentist? || user_is_patient? || user_is_inactive?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end
    @id_ap = params[:id_ap]
  end

  def edit_p_agendar
    if user_is_dentist? || user_is_patient? || user_is_inactive?
      redirect_to root_path, alert: "Lo sentimos, no puedes ver esto."
    end

    @id_ap = params[:id_ap]
    @appointment = Appointment.find(@id_ap)
    @fecha_recibida = params[:fecha_t]
    @dentist_recibido = @appointment.dentist_id

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

# POST /appointments or /appointments.json
  def create
    begin
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

    rescue ActiveRecord::RecordNotUnique => e
      flash[:notice] = "La cita ya existe."
      redirect_to calendar_path
    rescue => e
      flash[:alert] = "Ocurrió un error al crear la cita."
      redirect_to calendar_path
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
    if user_is_admin?
      @appointment.destroy!

      respond_to do |format|
        format.html { redirect_to appointments_url, notice: "La cita fue destruida correctamente." }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:start_time, :time, :status_id, :user_id, :dentist_id, :urgencia_id, :mensaje)
  end
end

