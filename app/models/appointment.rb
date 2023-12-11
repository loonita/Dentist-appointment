class Appointment < ApplicationRecord

  after_create :send_email
  validates :dentist_id , presence: true
  validates :user_id , presence: true
  validates :start_time, presence: true
  validates :time, presence: true

  has_one :status
  belongs_to :user


  def fecha
    start_time.strftime("%d/%m/%Y")
  end

  def hora
    time.strftime("%H:%M")
  end


  def nombre_dentista
    "Dra. #{User.find(dentist_id).name} #{User.find(user_id).last_name}"
  end

  def nombre_paciente
    "#{User.find(user_id).name} #{User.find(user_id).last_name}"
  end

  def cita_calendar
    hora + " " + nombre_paciente
  end
  

  def send_email
    UserMailer.appointment_confirmation(user).deliver
  end

end

