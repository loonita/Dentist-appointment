class Appointment < ApplicationRecord
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

end
