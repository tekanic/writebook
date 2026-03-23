class Delivery < ApplicationRecord
  belongs_to :campaign
  belongs_to :subscriber

  enum :status, { pending: "pending", sent: "sent", opened: "opened", clicked: "clicked", bounced: "bounced", failed: "failed" }

  scope :pending, -> { where(status: :pending) }
end
