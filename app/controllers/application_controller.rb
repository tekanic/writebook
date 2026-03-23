class ApplicationController < ActionController::Base
  include Authentication, Authorization, VersionHeaders

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_account_from_subdomain

  private
    def set_account_from_subdomain
      return if Current.account.present? && Current.user.present?

      if request.subdomain.present? && request.subdomain != "www"
        Current.account = Account.find_by(subdomain: request.subdomain)
      end
    end
end
