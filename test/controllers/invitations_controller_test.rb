require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "redirects to the friendships page" do
    get invitations_index_url
    assert_redirected_to friendships_path
  end
end
