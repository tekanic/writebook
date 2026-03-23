class Webhooks::ResendController < ApplicationController
  skip_before_action :require_authentication
  skip_forgery_protection

  def create
    payload = JSON.parse(request.body.read)
    event_type = payload["type"]
    data = payload["data"]

    case event_type
    when "email.delivered"
      # Already tracked via delivery job
    when "email.opened"
      OpenTrackingJob.perform_later(resend_message_id: data["email_id"])
    when "email.clicked"
      ClickTrackingJob.perform_later(resend_message_id: data["email_id"])
    when "email.bounced"
      BounceProcessingJob.perform_later(resend_message_id: data["email_id"])
    when "email.complained"
      BounceProcessingJob.perform_later(resend_message_id: data["email_id"])
    end

    head :ok
  end
end
