class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.integer :status
      t.string :name
      t.string :email
      t.string :phone_number
      t.datetime :time
      t.string :dentist

      t.timestamps
    end
  end
end
