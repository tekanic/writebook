class ResendDomainService
  def initialize(sending_domain)
    @sending_domain = sending_domain
  end

  def create_domain
    return unless resend_configured?

    response = Resend::Domains.create(name: @sending_domain.domain)
    @sending_domain.update!(
      resend_domain_id: response[:id],
      dns_records: response[:records] || {},
      status: :verifying
    )
    response
  end

  def verify_domain
    return unless resend_configured?
    return unless @sending_domain.resend_domain_id.present?

    response = Resend::Domains.verify(@sending_domain.resend_domain_id)
    @sending_domain.increment!(:verification_attempts)

    if response[:status] == "verified"
      @sending_domain.update!(status: :verified)
    elsif @sending_domain.verification_expired?
      @sending_domain.update!(status: :failed)
    end

    response
  end

  def delete_domain
    return unless resend_configured?
    return unless @sending_domain.resend_domain_id.present?

    Resend::Domains.remove(@sending_domain.resend_domain_id)
    @sending_domain.destroy
  end

  private
    def resend_configured?
      ENV["RESEND_API_KEY"].present?
    end
end
