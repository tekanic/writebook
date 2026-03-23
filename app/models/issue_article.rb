class IssueArticle < ApplicationRecord
  belongs_to :issue
  belongs_to :leaf

  validates :leaf_id, uniqueness: { scope: :issue_id }

  scope :positioned, -> { order(:position_score) }
end
