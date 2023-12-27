require "test_helper"

class UrgenciaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @urgencium = urgencia(:one)
  end

  test "should get index" do
    get urgencia_url
    assert_response :success
  end

  test "should get new" do
    get new_urgencium_url
    assert_response :success
  end

  test "should create urgencium" do
    assert_difference("Urgencium.count") do
      post urgencia_url, params: { urgencium: { name: @urgencium.name } }
    end

    assert_redirected_to urgencium_url(Urgencium.last)
  end

  test "should show urgencium" do
    get urgencium_url(@urgencium)
    assert_response :success
  end

  test "should get edit" do
    get edit_urgencium_url(@urgencium)
    assert_response :success
  end

  test "should update urgencium" do
    patch urgencium_url(@urgencium), params: { urgencium: { name: @urgencium.name } }
    assert_redirected_to urgencium_url(@urgencium)
  end

  test "should destroy urgencium" do
    assert_difference("Urgencium.count", -1) do
      delete urgencium_url(@urgencium)
    end

    assert_redirected_to urgencia_url
  end
end
