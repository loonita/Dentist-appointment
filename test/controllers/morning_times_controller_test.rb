require "test_helper"

class MorningTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @morning_time = morning_times(:one)
  end

  test "should get index" do
    get morning_times_url
    assert_response :success
  end

  test "should get new" do
    get new_morning_time_url
    assert_response :success
  end

  test "should create morning_time" do
    assert_difference("MorningTime.count") do
      post morning_times_url, params: { morning_time: { m_time: @morning_time.m_time } }
    end

    assert_redirected_to morning_time_url(MorningTime.last)
  end

  test "should show morning_time" do
    get morning_time_url(@morning_time)
    assert_response :success
  end

  test "should get edit" do
    get edit_morning_time_url(@morning_time)
    assert_response :success
  end

  test "should update morning_time" do
    patch morning_time_url(@morning_time), params: { morning_time: { m_time: @morning_time.m_time } }
    assert_redirected_to morning_time_url(@morning_time)
  end

  test "should destroy morning_time" do
    assert_difference("MorningTime.count", -1) do
      delete morning_time_url(@morning_time)
    end

    assert_redirected_to morning_times_url
  end
end
