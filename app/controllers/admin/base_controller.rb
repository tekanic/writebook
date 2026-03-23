class Admin::BaseController < ApplicationController
  before_action :require_admin!
  layout "admin"

  private
    def require_admin!
      unless Current.user&.platform_admin?
        head :forbidden
      end
    end
end
