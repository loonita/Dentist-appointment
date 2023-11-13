class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :appointments
  belongs_to :role

  validates :name, :last_name, :phone, :role_id, presence: true

  def name_dentist
    "Dra. #{name} #{last_name}"
  end
end
