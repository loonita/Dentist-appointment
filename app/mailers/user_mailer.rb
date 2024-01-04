class UserMailer < ApplicationMailer


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.appointment_confirmation.subject


  def post_email(user)
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Te has registrado con éxito")
  end

  def appointment_confirmation(user, appointment)
    @patient = user
    @appointment = appointment
    @dentist = User.find(appointment.dentist_id)
    mail to: user.email , :subject => "Cita agendada en Clínica Dental San Antonio"
  end

  def appointment_reminder(user, appointment)
    @patient = user
    @appointment = appointment
    @dentist = User.find(appointment.dentist_id)
    mail to: user.email , :subject => "Confirma tu cita en Clínica Dental San Antonio"
  end

  def appointment_followup_reminder(user)
    @patient = user
    mail to: user.email, subject: "Recuerda realizar un chequeo dental"
  end

end
