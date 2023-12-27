require "application_system_test_case"

class UrgenciaTest < ApplicationSystemTestCase
  setup do
    @urgencium = urgencia(:one)
  end

  test "visiting the index" do
    visit urgencia_url
    assert_selector "h1", text: "Urgencia"
  end

  test "should create urgencium" do
    visit urgencia_url
    click_on "New urgencium"

    fill_in "Name", with: @urgencium.name
    click_on "Create Urgencium"

    assert_text "Urgencium was successfully created"
    click_on "Back"
  end

  test "should update Urgencium" do
    visit urgencium_url(@urgencium)
    click_on "Edit this urgencium", match: :first

    fill_in "Name", with: @urgencium.name
    click_on "Update Urgencium"

    assert_text "Urgencium was successfully updated"
    click_on "Back"
  end

  test "should destroy Urgencium" do
    visit urgencium_url(@urgencium)
    click_on "Destroy this urgencium", match: :first

    assert_text "Urgencium was successfully destroyed"
  end
end
