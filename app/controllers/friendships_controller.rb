class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]
  
  def index
    @friends = Current.user.accepted_friends.order(:name)

    @sent_requests = Current.user.sent_friendships
                            .pending
                            .includes(:friend)

    @received_requests = Current.user.received_friendships
                                .pending
                                .includes(:user)
  end

  def create
    friend = User.find_by(
      # id: params[:friend_id]
      email_address: params[:friend_email].to_s.strip.downcase
      )

    unless friend
      redirect_to friendships_path, 
          alert: 'No user found with that email address'
      return
    end

    friendship = Current.user
                .sent_friendships.new(friend: friend)

    if friendship.save
      redirect_to friendships_path, notice: 'Friend request sent'
    else
      redirect_to friendships_path, 
      alert: friendship.errors.full_messages.to_sentence
    end
  end

  def update
    unless @friendship.friend_id == Current.user.id
      head :forbidden
      return
    end

    unless @friendship.pending?
      redirect_to friendships_path,
              alert: "This request is no longer pending."
      return
    end


    case params[:status]
    when "accepted"
      @friendship.update!(status: 'accepted')
      redirect_to friendships_path, 
            notice: 'Friend request accepted'
    when "declined"
      @friendship.update!(status: 'declined')
      redirect_to friendships_path, 
            notice: 'Friend request declined'
    else
      redirect_to friendships_path, 
            alert: 'Invalid request'
    end
    
  end

  def destroy
    unless [@friendship.user_id, @friendship.friend_id]
            .include?(Current.user.id)
      head :forbidden
      return
    end

    @friendship.destroy
    redirect_to friendships_path, notice: "Friendship removed"
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
