# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/appointment_confirmation
  def appointment_confirmation
    UserMailer.appointment_confirmation
  end
  def appointment_reminder
    UserMailer.appointment_reminder
  end


end
