class OpenTrackingJob < ApplicationJob
  queue_as :default

  def perform(resend_message_id:)
    delivery = Delivery.find_by(resend_message_id: resend_message_id)
    return unless delivery
    return if delivery.opened?

    delivery.update!(status: :opened, opened_at: Time.current)
    delivery.campaign.increment!(:open_count)
  end
end
