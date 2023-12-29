namespace :appointments do
  desc "Actualizar estado de las citas si la fecha de la cita ya expiró"
  task actualizar_estado: :environment do
    Appointment.where('start_time < ?', Date.today).update_all(status_id: '4')
  end
end
