require "application_system_test_case"

class AppointmentsTest < ApplicationSystemTestCase
  setup do
    @appointment = appointments(:one)
  end

  test "visiting the index" do
    visit appointments_url
    assert_selector "h1", text: "Appointments"
  end

  test "should create appointment" do
    visit appointments_url
    click_on "New appointment"

    fill_in "Date", with: @appointment.date
    fill_in "Email", with: @appointment.email
    fill_in "Last name", with: @appointment.last_name
    fill_in "Name", with: @appointment.name
    fill_in "Phone number", with: @appointment.phone_number
    fill_in "Rut", with: @appointment.rut
    fill_in "Time", with: @appointment.time
    click_on "Create Appointment"

    assert_text "Appointment was successfully created"
    click_on "Back"
  end

  test "should update Appointment" do
    visit appointment_url(@appointment)
    click_on "Edit this appointment", match: :first

    fill_in "Date", with: @appointment.date
    fill_in "Email", with: @appointment.email
    fill_in "Last name", with: @appointment.last_name
    fill_in "Name", with: @appointment.name
    fill_in "Phone number", with: @appointment.phone_number
    fill_in "Rut", with: @appointment.rut
    fill_in "Time", with: @appointment.time
    click_on "Update Appointment"

    assert_text "Appointment was successfully updated"
    click_on "Back"
  end

  test "should destroy Appointment" do
    visit appointment_url(@appointment)
    click_on "Destroy this appointment", match: :first

    assert_text "Appointment was successfully destroyed"
  end
end
