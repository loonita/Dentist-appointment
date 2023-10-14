require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment = appointments(:one)
  end

  test "should get index" do
    get appointments_url, as: :json
    assert_response :success
  end

  test "should create appointment" do
    assert_difference("Appointment.count") do
      post appointments_url, params: { appointment: { customer_paid: @appointment.customer_paid, email: @appointment.email, first_name: @appointment.first_name, last_name: @appointment.last_name, phone_number: @appointment.phone_number, status: @appointment.status, time: @appointment.time } }, as: :json
    end

    assert_response :created
  end

  test "should show appointment" do
    get appointment_url(@appointment), as: :json
    assert_response :success
  end

  test "should update appointment" do
    patch appointment_url(@appointment), params: { appointment: { customer_paid: @appointment.customer_paid, email: @appointment.email, first_name: @appointment.first_name, last_name: @appointment.last_name, phone_number: @appointment.phone_number, status: @appointment.status, time: @appointment.time } }, as: :json
    assert_response :success
  end

  test "should destroy appointment" do
    assert_difference("Appointment.count", -1) do
      delete appointment_url(@appointment), as: :json
    end

    assert_response :no_content
  end
end
