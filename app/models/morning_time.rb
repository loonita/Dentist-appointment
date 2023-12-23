class MorningTime < ApplicationRecord

  belongs_to :appointment, :required => false

  validates :m_time, presence: true

  def hora
  end

end
