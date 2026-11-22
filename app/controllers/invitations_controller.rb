require "securerandom"
require "digest"

class InvitationsController < ApplicationController
  def index
    @invitations = Current.user
                          .sent_friend_invitations
                          .order(created_at: :desc)
  end

  def create
    email = params[:email].to_s.strip.downcase

    if email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)
      redirect_to invitations_path,
                  alert: "Please enter a valid email address."
      return
    end

    if email == Current.user.email_address.to_s.downcase
      redirect_to invitations_path,
                  alert: "You cannot invite yourself."
      return
    end

    if User.exists?(email_address: email)
      redirect_to invitations_path,
                  alert: "This person already has a Recs account."
      return
    end

    token = SecureRandom.urlsafe_base64(32)
    token_digest = Digest::SHA256.hexdigest(token)

    invitation = Current.user.sent_friend_invitations
                        .find_or_initialize_by(email: email)

    invitation.assign_attributes(
      token_digest: token_digest,
      expires_at: 7.days.from_now,
      accepted_at: nil
    )

    if invitation.save
      FriendInvitationMailer.with(
        invitation: invitation,
        token: token
      ).invite.deliver_now

      redirect_to invitations_path,
                  notice: "Invitation sent to #{email}."
    else
      redirect_to invitations_path,
                  alert: invitation.errors.full_messages.to_sentence
    end
  end
end
