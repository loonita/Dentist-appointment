class Appointment < ApplicationRecord

  after_create :send_email
  validates :dentist_id , presence: true
  validates :user_id , presence: true
  before_save :sum_start_time_and_time, if: :should_sum_start_time?

  #validates :start_time, presence: true
  #validates :time, presence: true

  has_one :status
  has_one :urgencium
  has_one :morning_times
  belongs_to :user

  def self.search_by_patient_name(query)
    # Normaliza el término de búsqueda
    normalized_query = normalize_string(query)

    # Realiza la búsqueda utilizando el término normalizado
    joins(:user).where(
      'unaccent(lower(users.name)) LIKE :query OR ' \
      'unaccent(lower(users.last_name)) LIKE :query OR ' \
      'unaccent(lower(users.rut)) LIKE :query ',
      query: "%#{normalized_query}%"
    )
  end

  def fecha
    return '-' if start_time.nil?

    start_time.strftime("%d/%m/%Y")
  end

  def hora
    return '-' if time.nil?

    time.strftime("%H:%M")
  end

  def nombre_dentista
    "Dra. #{User.find(dentist_id).name} #{User.find(dentist_id).last_name}"
  end

  def id_dentista
    User.find(dentist_id).id
  end

  def rut_dentista
    User.find(dentist_id).rut
  end
  def nombre_paciente
    "#{User.find(user_id).name} #{User.find(user_id).last_name}"
  end

  def rut_paciente
    User.find(user_id).rut
  end

  def cita_calendar
    hora + " " + nombre_paciente
  end

  def cita_calendar_dentista
    hora + " " + nombre_dentista
  end

  
  def send_email
    UserMailer.appointment_confirmation(user).deliver
  end

  private

  def sum_start_time_and_time
    return unless start_time && time && should_sum_start_time?

    new_start_time = start_time + time.seconds_since_midnight.seconds
    self.start_time = new_start_time

    # Marca el objeto para solo sumar una vez
    self.should_sum_start_time = false
  end

  def should_sum_start_time?
    should_sum_start_time.nil? || should_sum_start_time
  end

  def self.normalize_string(str)
    # Normaliza el texto: convierte a minúsculas y elimina acentos
    I18n.transliterate(str.to_s.downcase)
  end

end

