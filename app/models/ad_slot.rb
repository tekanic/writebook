class AdSlot < ApplicationRecord
  belongs_to :book

  has_many :ad_purchases, dependent: :destroy

  enum :position, { top: "top", middle: "middle", bottom: "bottom" }
  enum :pricing_model, { flat: "flat", cpm: "cpm", cpc: "cpc" }

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(listed: true) }
  scope :for_dates, ->(date) { where("available_from <= ? AND available_to >= ?", date, date) }
end
