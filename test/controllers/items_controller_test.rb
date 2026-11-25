require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get show" do
    get item_url(items(:one))
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(items(:one))
    assert_response :success
  end
end
