class Admin::AccountsController < Admin::BaseController
  before_action :set_account, only: %i[show impersonate]

  def index
    @accounts = Account.order(created_at: :desc)
    @accounts = @accounts.where("name LIKE ?", "%#{params[:q]}%") if params[:q].present?
  end

  def show
  end

  def impersonate
    user = @account.users.active.first
    if user
      AuditLog.record!(
        action: "impersonate",
        target_account: @account,
        metadata: { impersonated_user_id: user.id },
        ip_address: request.remote_ip
      )
      start_new_session_for(user)
      redirect_to root_url, notice: "Now viewing as #{user.name} (#{@account.name})"
    else
      redirect_to admin_account_path(@account), alert: "No active users on this account."
    end
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end
end
