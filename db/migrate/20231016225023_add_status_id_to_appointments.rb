class AddStatusIdToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_reference :appointments, :status, null: false, foreign_key: true, default: 1
  end
end
