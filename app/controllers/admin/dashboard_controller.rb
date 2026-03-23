class Admin::DashboardController < Admin::BaseController
  def show
    @total_accounts = Account.count
    @total_users = User.active.count
    @total_subscribers = Subscriber.active.count
    @total_campaigns = Campaign.count
    @recent_campaigns = Campaign.order(created_at: :desc).limit(10)
    @recent_audit_logs = AuditLog.recent.limit(20).includes(:user)
  end
end
