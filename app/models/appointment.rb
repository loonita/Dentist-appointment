class Appointment < ApplicationRecord
  validates :name , presence: true
  validates :last_name , presence: true
  validates :rut , presence: true
  validates :email , presence: true
  validates :phone_number , presence: true
  validates :date , presence: true
  validates :time , presence: true

  has_one :status
  belongs_to :user


end
