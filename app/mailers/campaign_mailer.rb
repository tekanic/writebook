class CampaignMailer < ApplicationMailer
  layout "campaign_email"

  def campaign_email(delivery)
    @delivery = delivery
    @campaign = delivery.campaign
    @issue = @campaign.issue
    @book = @issue.book
    @branding = @book.publication_branding
    @subscriber = delivery.subscriber
    @subject = @issue.subject

    @unsubscribe_url = unsubscribe_url(token: @subscriber.unsubscribe_token)
    @web_version_url = issue_web_url(slug: @issue.slug)

    renderer = IssueRenderer.new(book: @book, articles: @issue.articles)
    @html_content = renderer.render_html

    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>"
    headers["List-Unsubscribe-Post"] = "List-Unsubscribe=One-Click"

    mail(
      to: @subscriber.email_address,
      subject: @issue.subject,
      from: from_address
    ) do |format|
      format.html { render html: @html_content.html_safe, layout: "campaign_email" }
      format.text { render plain: renderer.render_text }
    end
  end

  private
    def from_address
      name = @branding&.from_name.presence || @book.title
      "#{name} <#{default_params[:from]}>"
    end
end
