class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item

  # has_many_attached :photos

  validates :rating, inclusion: { in: 1..5 }
  validates :body, presence: true

  scope :newest_first, -> {
    order(created_at: :desc)
  }

  scope :visible_to, ->(viewer) {
    where(user_id: viewer.accepted_friends.select(:id))
      .or(where(user_id: viewer.id))
  }

  def readable_by?(viewer)
    return false unless viewer

    user_id == viewer.id ||
      viewer.accepted_friends.where(id: user_id).exists?
  end
end
