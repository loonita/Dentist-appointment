namespace :appointment_reminders do
  desc "Envia correos de recordatorio de citas"
  task send_reminders: :environment do
    Appointment.all.each do |a|
      next if a.start_time.nil?

      if a.start_time.to_date == Date.tomorrow
        UserMailer.appointment_reminder(a.user, a).deliver_now
      end
    end
  end
  desc "Envia recordatorios a los pacientes 6 meses después de su última cita agendada."
  task send_followup_reminders: :environment do
    User.all.each do |u|
      next if u.role_id != 1  # si no es paciente, pasamos al siguiente usuario
      next if u.appointments.none? # si no ha tenido citas, pasamos al siguiente usuario
      last_appointment = u.appointments.max_by { |a| a[:start_time] }

      next if last_appointment.nil?
      next if last_appointment.start_time.to_date != Date.today - 6.months

      UserMailer.appointment_followup_reminder(u).deliver_now
    end
  end
end