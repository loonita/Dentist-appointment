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
end