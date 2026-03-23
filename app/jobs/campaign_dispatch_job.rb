class CampaignDispatchJob < ApplicationJob
  queue_as :email

  BATCH_SIZE = 100

  def perform(campaign)
    campaign.update!(status: :delivering)

    campaign.deliveries.pending.in_batches(of: BATCH_SIZE) do |batch|
      batch.each do |delivery|
        CampaignDeliveryJob.perform_later(delivery)
      end
    end
  end
end
