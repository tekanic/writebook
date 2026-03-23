class ClickTrackingController < ApplicationController
  allow_unauthenticated_access
  skip_forgery_protection

  def show
    click = AdClick.find_by!(token: params[:token])
    creative = click.ad_creative

    # Block private IPs
    if AdClick.private_ip?(request.remote_ip)
      head :forbidden
      return
    end

    # Update click record
    click.update!(ip_address: request.remote_ip, user_agent: request.user_agent)

    # Redirect to destination
    redirect_to creative.destination_url, allow_other_host: true
  end
end
