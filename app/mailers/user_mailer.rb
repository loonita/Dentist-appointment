class UserMailer < ApplicationMailer


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.appointment_confirmation.subject


  def post_email(user)
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end

  def appointment_confirmation(user, appointment)
    @name = user.name
    @appointment = appointment
    @dentist = User.find(appointment.dentist_id)
    mail to: user.email , :subject => "Appointment Confirmation"
  end

  def appointment_reminder(user, appointment)
    @name = user.name
    @appointment = appointment
    @dentist = User.find(appointment.dentist_id)
    mail to: user.email , :subject => "Appointment Reminder"
  end

  def appointment_followup_reminder(user)
    mail to: user.email, subject: "Recordatorio periodico de 6 meses"
  end

end
