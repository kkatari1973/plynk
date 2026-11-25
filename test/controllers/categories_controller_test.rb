require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get show" do
    get category_url(categories(:one).slug)
    assert_response :success
  end
end
