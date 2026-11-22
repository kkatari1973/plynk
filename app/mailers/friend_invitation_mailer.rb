
class FriendInvitationMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]
    @inviter = @invitation.user
    @token = params[:token]

    mail(
      to: @invitation.email,
      subject: "#{@inviter.name} invited you to join Recs"
    )
  end
end
