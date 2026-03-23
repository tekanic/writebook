class BounceProcessingJob < ApplicationJob
  queue_as :email

  def perform(resend_message_id:)
    delivery = Delivery.find_by(resend_message_id: resend_message_id)
    return unless delivery

    delivery.update!(status: :bounced, bounced_at: Time.current)
    delivery.campaign.increment!(:bounce_count)
    delivery.subscriber.update!(status: :bounced)
  end
end
