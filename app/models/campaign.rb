class Campaign < ApplicationRecord
  belongs_to :issue

  has_many :deliveries, dependent: :destroy

  enum :status, { pending: "pending", dispatching: "dispatching", delivering: "delivering", completed: "completed", failed: "failed" }

  def dispatch!
    update!(status: :dispatching)
    CampaignDispatchJob.perform_later(self)
  end

  def total_recipients
    deliveries.count
  end

  def open_rate
    return 0 if sent_count.zero?
    (open_count.to_f / sent_count * 100).round(1)
  end

  def click_rate
    return 0 if sent_count.zero?
    (click_count.to_f / sent_count * 100).round(1)
  end
end
