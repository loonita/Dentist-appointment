require "application_system_test_case"

class RolsTest < ApplicationSystemTestCase
  setup do
    @rol = rols(:one)
  end

  test "visiting the index" do
    visit rols_url
    assert_selector "h1", text: "Rols"
  end

  test "should create rol" do
    visit rols_url
    click_on "New rol"

    fill_in "Name", with: @rol.name
    click_on "Create Rol"

    assert_text "Rol was successfully created"
    click_on "Back"
  end

  test "should update Rol" do
    visit rol_url(@rol)
    click_on "Edit this rol", match: :first

    fill_in "Name", with: @rol.name
    click_on "Update Rol"

    assert_text "Rol was successfully updated"
    click_on "Back"
  end

  test "should destroy Rol" do
    visit rol_url(@rol)
    click_on "Destroy this rol", match: :first

    assert_text "Rol was successfully destroyed"
  end
end
