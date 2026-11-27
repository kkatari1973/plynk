require "test_helper"

class FriendInvitationMailerTest < ActionMailer::TestCase
  test "invite" do
    mail = FriendInvitationMailer.with(
      invitation: friend_invitations(:one),
      token: "test-token"
    ).invite

    assert_equal "One User invited you to join Recs", mail.subject
    assert_equal [ "invite-one@example.com" ], mail.to
    assert_equal [ "invites@mail.plynk.com" ], mail.from
    assert_match "One User has invited you to join Recs", mail.body.encoded
    assert_match "test-token", mail.body.encoded
  end
end
