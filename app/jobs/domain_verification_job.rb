class DomainVerificationJob < ApplicationJob
  queue_as :default

  def perform(sending_domain)
    return if sending_domain.verified? || sending_domain.failed?

    service = ResendDomainService.new(sending_domain)
    service.verify_domain

    # Re-enqueue if still verifying
    if sending_domain.reload.verifying?
      self.class.set(wait: 15.minutes).perform_later(sending_domain)
    end
  end
end
