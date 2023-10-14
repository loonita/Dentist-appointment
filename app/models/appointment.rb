class Appointment < ApplicationRecord::Base
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :time, presence: true
end


