class MorningTime < ApplicationRecord

  has_many :appointments

  validates :m_time, presence: true

  def hora
  end

end
