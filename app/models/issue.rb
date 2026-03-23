class Issue < ApplicationRecord
  belongs_to :book

  has_many :issue_articles, dependent: :destroy
  has_many :leaves, through: :issue_articles
  has_many :campaigns, dependent: :destroy

  enum :status, { draft: "draft", scheduled: "scheduled", sending: "sending", sent: "sent" }

  validates :subject, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  before_create :generate_slug

  def articles
    issue_articles.order(:position_score).includes(leaf: :leafable).map { |ia| ia.leaf.leafable }
  end

  private
    def generate_slug
      self.slug ||= "#{subject.parameterize}-#{SecureRandom.hex(4)}"
    end
end
