class Status < ApplicationRecord

  belongs_to :appointment, :required => false

end
