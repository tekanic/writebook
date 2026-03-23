class GeneratedArticle < ApplicationRecord
  belongs_to :article_source
  belongs_to :account
  belongs_to :page, optional: true

  enum :status, { pending: "pending", published: "published", rejected: "rejected" }

  validates :title, presence: true
  validates :body_markdown, presence: true
  validates :attribution_html, presence: true

  def total_tokens
    input_tokens + output_tokens
  end

  def publish_to_book!(book)
    page = Page.create!
    page.update!(body: body_with_attribution)
    leaf = book.press(page, title: title)
    update!(status: :published, page: page)
    leaf
  end

  def body_with_attribution
    "#{body_markdown}\n\n---\n\n#{attribution_html}"
  end
end
