class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  
  enum :status, { 
    pending: "pending", 
    accepted: "accepted", 
    declined: "declined" 
  }

  validates :friend_id, uniqueness: { 
    scope: :user_id, 
    message: "Friend request already sent" }

  validate :cannot_friend_yourself
  validate :cannot_duplicate_friendship

  private

  def cannot_friend_yourself
    if user_id == friend_id
      errors.add(:friend_id, "You cannot send a friend 
                                request to yourself")
    end
  end


  def cannot_duplicate_friendship
    return unless user_id && friend_id

    duplicate = Friendship.where(
      "(user_id = :user AND friend_id = :friend) OR " \
      "(user_id = :friend AND friend_id = :user)",
      user: user_id,
      friend: friend_id
    )

    duplicate = duplicate.where.not(id: id) if persisted?

    if duplicate.exists?
      errors.add(:base, "Friendship already exists")
    end
  end
end