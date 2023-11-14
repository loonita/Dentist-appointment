class Status < ApplicationRecord

  belongs_to :appointment, :required => false

  validates :name, presence: true, uniqueness: true

end
