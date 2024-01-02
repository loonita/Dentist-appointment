namespace :appointment_reminders do
  desc "Envia correos de recordatorio de citas"
  task send_reminders: :environment do
    Appointment.all.each do |a|
      next if a.start_time.nil?

      if a.start_time.to_date == Date.tomorrow
        UserMailer.appointment_reminder(a.user).deliver_now
      end
    end
  end
  desc "Envia recordatorios a los pacientes 6 meses después de su última cita agendada."
  task send_followup_reminder: :environment do
    User.all.each do |u|
      next if u.role_id != 1  # si no es paciente, pasamos al siguiente usuario
      next if u.appointments.none? # si no ha tenido citas, pasamos al siguiente usuario

      sorted_appointments = u.appointments.max_by { |s| s[:start_time] }  # ordenamos por fecha de cita
      next if sorted_appointments.nil? || sorted_appointments.empty?

      last_appointment = sorted_appointments.first  # tomamos la última cita del paciente
      next if last_appointment.start_time != Date.today - 6.months # pasamos al siguiente paciente si la cita no fue exactamente 6 meses atrás

      UserMailer.appointment_reminder(u).deliver_now
    end
  end
end