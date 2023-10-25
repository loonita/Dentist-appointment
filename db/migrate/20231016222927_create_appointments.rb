class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :rut, null: false
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone_number, null: false
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
