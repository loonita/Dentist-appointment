require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "appointment_confirmation" do
    mail = UserMailer.appointment_confirmation
    assert_equal "Appointment confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
