class AuditLog < ApplicationRecord
  belongs_to :user
  belongs_to :target_account, class_name: "Account", optional: true

  validates :action, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def self.record!(action:, user: Current.user, target_account: nil, metadata: {}, ip_address: nil)
    create!(
      user: user,
      target_account: target_account,
      action: action,
      metadata: metadata,
      ip_address: ip_address
    )
  end
end
