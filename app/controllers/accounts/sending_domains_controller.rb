class Accounts::SendingDomainsController < ApplicationController
  before_action :ensure_can_administer
  before_action :set_sending_domain, only: %i[show verify destroy]

  def index
    @sending_domains = Current.account.sending_domains
  end

  def new
    @sending_domain = SendingDomain.new
  end

  def create
    @sending_domain = Current.account.sending_domains.build(sending_domain_params)

    if @sending_domain.save
      service = ResendDomainService.new(@sending_domain)
      service.create_domain
      DomainVerificationJob.set(wait: 1.minute).perform_later(@sending_domain)

      redirect_to account_sending_domain_path(@sending_domain), notice: "Domain added. Configure your DNS records below."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def verify
    service = ResendDomainService.new(@sending_domain)
    service.verify_domain

    redirect_to account_sending_domain_path(@sending_domain),
      notice: @sending_domain.verified? ? "Domain verified!" : "Verification in progress..."
  end

  def destroy
    service = ResendDomainService.new(@sending_domain)
    service.delete_domain

    redirect_to account_sending_domains_path, notice: "Domain removed."
  end

  private
    def set_sending_domain
      @sending_domain = Current.account.sending_domains.find(params[:id])
    end

    def sending_domain_params
      params.require(:sending_domain).permit(:domain)
    end
end
