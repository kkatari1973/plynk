require "digest"
class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @user = User.new
    @invitation = find_invitation(params[:invitation])

    if params[:invitation].present?
      if @invitation
        @user.email_address = @invitation.email
      else
        @user.errors.add(
          :base,
          "This invitation is invalid, expired, or has already been used."
        )
      end
    end
  end

  def create
    @user = User.new(user_params)
    token = params[:invitation].to_s
    @invitation = find_invitation(token) if token.present?

    # If an invitation token was supplied, it must be valid.
    if token.present? && !@invitation
      @user.errors.add(
        :base,
        "This invitation is invalid, expired, or has already been used."
      )
      return render :new, status: :unprocessable_entity
    end

    # The registering email must match the invited email.
    if @invitation &&
       @user.email_address.to_s.strip.downcase != @invitation.email
      @user.errors.add(
        :email_address,
        "must match the email address that received the invitation."
      )
      return render :new, status: :unprocessable_entity
    end

    begin
      ActiveRecord::Base.transaction do
        @user.save!

        if @invitation
          Friendship.create!(
            user: @invitation.user,
            friend: @user,
            status: :accepted
          )

          @invitation.update!(accepted_at: Time.current)
        end
      end

      start_new_session_for(@user)

      redirect_to root_path,
                  notice: @invitation ?
                    "Welcome! Your account has been created and you are now friends." :
                    "Welcome! Your account has been created."

    rescue ActiveRecord::RecordInvalid => error
      unless error.record == @user
        @user.errors.add(:base, error.record.errors.full_messages.to_sentence)
      end

      render :new, status: :unprocessable_entity
    end
  end

  private

  def find_invitation(token)
    return nil if token.blank?

    digest = Digest::SHA256.hexdigest(token)

    FriendInvitation.active.find_by(token_digest: digest)
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation
    )
  end
end
