require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get reviews_url
    assert_response :success
  end

  test "should get show" do
    get review_url(reviews(:one))
    assert_response :success
  end

  test "should get new" do
    get new_item_review_url(items(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_review_url(reviews(:one))
    assert_response :success
  end
end
