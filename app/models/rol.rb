class Rol < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception
end
