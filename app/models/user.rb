class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  NOMBRE_REGEX = /\A([A-Za-z]{1,256})\z/


  has_many :appointments
  belongs_to :role

  validates :name, :last_name, :phone, :role_id, presence: true
  validates :rut, presence: true, uniqueness: true, rut: true
  validates_format_of :name, :last_name, :with => NOMBRE_REGEX
  validates :phone , length: { minimum: 9, maximum: 9 }, numericality: { only_integer: true }




  def name_dentist
    "Dra. #{name} #{last_name}"
  end

  def rut_dentist
    "#{rut}"
  end

  def id_dentist
    "#{id}"
  end

  def name_patient
    "#{name} #{last_name}"
  end


  def rut_patient
    "#{rut}"
  end


end
