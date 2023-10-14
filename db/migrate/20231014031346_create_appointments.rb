class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.datetime :time
      t.boolean :customer_paid
      t.string :status

      t.timestamps
    end
  end
end
