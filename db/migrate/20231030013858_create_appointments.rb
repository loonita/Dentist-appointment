class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :start_time, null: true
      t.time :time, null: true

      t.integer :status_id, null: false, default: 1
      t.integer :user_id, null: false
      t.integer :dentist_id, null: false
      t.boolean :should_sum_start_time, null: false, default: true

      t.timestamps
    end
  end
end
