class SendingDomain < ApplicationRecord
  belongs_to :account

  encrypts :resend_domain_id

  enum :status, { pending: "pending", verifying: "verifying", verified: "verified", failed: "failed" }

  validates :domain, presence: true, uniqueness: true
  validates :domain, format: { with: /\A[a-z0-9]+([\-.][a-z0-9]+)*\.[a-z]{2,}\z/i, message: "must be a valid domain" }

  MAX_VERIFICATION_ATTEMPTS = 288 # 72 hours at 15-minute intervals

  def verification_expired?
    verification_attempts >= MAX_VERIFICATION_ATTEMPTS
  end
end
