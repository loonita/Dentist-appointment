class AddUniqueIndexToAppointmentsForPending < ActiveRecord::Migration[7.1]
  def change
    add_index :appointments, [:user_id], unique: true, where: "status_id IN (5)"
  end
end
