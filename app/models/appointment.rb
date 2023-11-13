class Appointment < ApplicationRecord

  after_create :send_email
  validates :dentist_id , presence: true
  validates :date , presence: true
  validates :time , presence: true

  has_one :status
  belongs_to :user

  def fecha
    date.strftime("%d/%m/%Y")
  end

  def hora
    time.strftime("%H:%M")
  end



  def send_email
    UserMailer.appointment_confirmation(user).deliver
  end

end
