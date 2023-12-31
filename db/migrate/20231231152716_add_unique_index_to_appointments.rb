class AddUniqueIndexToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_index :appointments, [:user_id, :dentist_id, :start_time, :time], unique: true, where: "status_id IN (1, 2)"
  end
end
