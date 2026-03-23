class AdPurchase < ApplicationRecord
  belongs_to :ad_slot
  belongs_to :ad_creative
  belongs_to :issue, optional: true

  enum :status, { pending: "pending", paid: "paid", refunded: "refunded" }

  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }
end
