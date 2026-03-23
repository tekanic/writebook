class PublicationBranding < ApplicationRecord
  belongs_to :book

  has_one_attached :logo
  has_one_attached :header_image

  validates :accent_color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color (e.g., #0066cc)" }, allow_blank: true
  validates :from_name, length: { maximum: 100 }
  validates :tagline, length: { maximum: 200 }
  validates :footer_text, length: { maximum: 500 }
  validates :font_family, inclusion: { in: %w[Arial Georgia Verdana Trebuchet\ MS Helvetica Times\ New\ Roman Courier\ New] }, allow_blank: true

  FONT_OPTIONS = [
    "Arial",
    "Georgia",
    "Verdana",
    "Trebuchet MS",
    "Helvetica",
    "Times New Roman",
    "Courier New"
  ].freeze
end
