class CampaignDeliveryJob < ApplicationJob
  queue_as :email

  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform(delivery)
    return if delivery.sent?

    CampaignMailer.campaign_email(delivery).deliver_now

    delivery.update!(status: :sent, sent_at: Time.current)
    delivery.campaign.increment!(:sent_count)
  rescue => e
    delivery.update!(status: :failed)
    delivery.campaign.increment!(:failed_count)
    raise e
  end
end
