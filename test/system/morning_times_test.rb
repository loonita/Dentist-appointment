require "application_system_test_case"

class MorningTimesTest < ApplicationSystemTestCase
  setup do
    @morning_time = morning_times(:one)
  end

  test "visiting the index" do
    visit morning_times_url
    assert_selector "h1", text: "Morning times"
  end

  test "should create morning time" do
    visit morning_times_url
    click_on "New morning time"

    fill_in "M time", with: @morning_time.m_time
    click_on "Create Morning time"

    assert_text "Morning time was successfully created"
    click_on "Back"
  end

  test "should update Morning time" do
    visit morning_time_url(@morning_time)
    click_on "Edit this morning time", match: :first

    fill_in "M time", with: @morning_time.m_time
    click_on "Update Morning time"

    assert_text "Morning time was successfully updated"
    click_on "Back"
  end

  test "should destroy Morning time" do
    visit morning_time_url(@morning_time)
    click_on "Destroy this morning time", match: :first

    assert_text "Morning time was successfully destroyed"
  end
end
