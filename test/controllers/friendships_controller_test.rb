require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "should get index" do
    get friendships_index_url
    assert_response :success
  end
end
