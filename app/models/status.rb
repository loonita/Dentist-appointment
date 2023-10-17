class Status < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :appointments, dependent: :restrict_with_exception
end
