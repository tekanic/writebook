class Advert < ApplicationRecord
  include Leafable

  has_one_attached :image

  validates :headline, presence: true, length: { maximum: 100 }
  validates :body_text, length: { maximum: 500 }
  validates :destination_url, format: { with: /\Ahttps?:\/\//i, message: "must be a valid URL" }, allow_blank: true
  validates :cta_text, length: { maximum: 30 }

  def searchable_content
    "#{headline} #{body_text}"
  end

  def markable
    headline
  end

  def safe_headline
    ActionController::Base.helpers.sanitize(headline, tags: [])
  end

  def safe_body_text
    ActionController::Base.helpers.sanitize(body_text.to_s, tags: [])
  end
end
