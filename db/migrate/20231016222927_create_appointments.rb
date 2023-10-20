class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :rut
      t.string :name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
