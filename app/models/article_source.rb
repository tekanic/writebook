class ArticleSource < ApplicationRecord
  belongs_to :account

  has_many :generated_articles, dependent: :destroy

  enum :fetch_frequency, { daily: "daily", weekly: "weekly" }
  enum :status, { active: "active", paused: "paused" }

  validates :url, presence: true, format: { with: /\Ahttps?:\/\//i, message: "must be a valid URL" }
  validates :name, presence: true

  scope :due_for_fetch, -> {
    active.where(
      "last_fetched_at IS NULL OR (fetch_frequency = 'daily' AND last_fetched_at < ?) OR (fetch_frequency = 'weekly' AND last_fetched_at < ?)",
      1.day.ago,
      1.week.ago
    )
  }
end
