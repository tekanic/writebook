class ClickTrackingJob < ApplicationJob
  queue_as :default

  def perform(resend_message_id:)
    delivery = Delivery.find_by(resend_message_id: resend_message_id)
    return unless delivery

    delivery.update!(status: :clicked, clicked_at: Time.current) unless delivery.clicked?
    delivery.campaign.increment!(:click_count)
  end
end
