class Subscriber < ApplicationRecord
  belongs_to :book

  has_secure_token :confirmation_token
  has_secure_token :unsubscribe_token

  has_many :deliveries, dependent: :destroy

  enum :status, { pending: "pending", active: "active", unsubscribed: "unsubscribed", bounced: "bounced" }

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_address, uniqueness: { scope: :book_id, case_sensitive: false }

  scope :confirmed, -> { where(status: :active) }
  scope :deliverable, -> { where(status: :active) }

  CONFIRMATION_EXPIRY = 72.hours

  def confirm!
    update!(status: :active, confirmed_at: Time.current)
  end

  def unsubscribe!
    update!(status: :unsubscribed)
  end

  def confirmation_expired?
    created_at < CONFIRMATION_EXPIRY.ago
  end
end
