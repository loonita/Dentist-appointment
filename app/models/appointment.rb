class Appointment < ApplicationRecord
  validates :date , presence: true
  validates :time , presence: true

  has_one :status
  belongs_to :user


end
