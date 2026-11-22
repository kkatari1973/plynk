
class FriendInvitation < ApplicationRecord
  belongs_to :user

  before_validation :normalize_email

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> {
    where(accepted_at: nil)
      .where("expires_at > ?", Time.current)
  }

  def expired?
    expires_at <= Time.current
  end

  def accepted?
    accepted_at.present?
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
