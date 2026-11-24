class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :reviews, dependent: :destroy

  # Friend requests sent by this user
  has_many :sent_friendships,
            class_name: "Friendship",
            foreign_key: :user_id,
            dependent: :destroy

  # Friends can register from invitations sent by this user
  has_many :sent_friend_invitations,
         class_name: "FriendInvitation",
         dependent: :destroy

  # Friend requests received by this user
  has_many :received_friendships,
         class_name: "Friendship",
         foreign_key: :friend_id,
         dependent: :destroy

  # All accepted friends, regardless of who initiated the request
  def accepted_friends
    sent_ids = sent_friendships.accepted.select(:friend_id)
    received_ids = received_friendships.accepted.select(
                    :user_id)

    User.where(id: sent_ids).or(User.where(id: received_ids))
  end
end
