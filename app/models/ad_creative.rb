class AdCreative < ApplicationRecord
  belongs_to :advertiser, class_name: "User"

  has_many :ad_purchases, dependent: :destroy
  has_many :ad_clicks, dependent: :destroy
  has_one_attached :image

  enum :status, { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :headline, presence: true, length: { maximum: 80 }
  validates :body_text, presence: true, length: { maximum: 300 }
  validates :destination_url, presence: true, format: { with: /\Ahttps:\/\//i, message: "must use HTTPS" }
  validates :cta_text, length: { maximum: 30 }

  after_create_commit :schedule_review

  def safe_headline
    ActionController::Base.helpers.sanitize(headline, tags: [])
  end

  def safe_body_text
    ActionController::Base.helpers.sanitize(body_text, tags: [])
  end

  private
    def schedule_review
      AdCreativeReviewJob.perform_later(self)
    end
end
