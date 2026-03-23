class Books::PreviewsController < ApplicationController
  include BookScoped

  before_action :ensure_editable
  rate_limit to: 1, within: 60.seconds, only: :create, with: -> { redirect_to edit_book_branding_path(@book), alert: "Please wait before sending another preview." }

  def show
    renderer = IssueRenderer.new(book: @book, articles: preview_articles)
    @html_content = renderer.render_html
    @branding = @book.publication_branding

    render layout: false
  end

  def create
    renderer = IssueRenderer.new(book: @book, articles: preview_articles)

    PreviewMailer.preview_email(
      user: Current.user,
      book: @book,
      html_content: renderer.render_html,
      text_content: renderer.render_text,
      subject: @book.title
    ).deliver_later

    redirect_to book_slug_path(@book), notice: "Preview email sent to #{Current.user.email_address}"
  end

  private
    def preview_articles
      @book.leaves.active.positioned.limit(5).map(&:leafable)
    end
end
