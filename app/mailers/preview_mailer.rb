class PreviewMailer < ApplicationMailer
  layout "campaign_email"

  def preview_email(user:, book:, html_content:, text_content:, subject:)
    @book = book
    @branding = book.publication_branding
    @subject = subject
    @html_content = html_content
    @unsubscribe_url = "#"
    @web_version_url = "#"

    mail(
      to: user.email_address,
      subject: "[PREVIEW] #{subject}",
      from: from_address(book)
    ) do |format|
      format.html { render html: @html_content.html_safe, layout: "campaign_email" }
      format.text { render plain: text_content }
    end
  end

  private
    def from_address(book)
      name = book.publication_branding&.from_name.presence || book.title
      "#{name} <#{default_params[:from]}>"
    end
end
