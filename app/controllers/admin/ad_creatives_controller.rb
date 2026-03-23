class Admin::AdCreativesController < Admin::BaseController
  before_action :set_ad_creative, only: %i[show approve reject]

  def index
    @ad_creatives = AdCreative.pending.order(created_at: :asc)
  end

  def show
  end

  def approve
    @ad_creative.update!(status: :approved)
    AuditLog.record!(action: "approve_ad_creative", metadata: { ad_creative_id: @ad_creative.id })
    redirect_to admin_ad_creatives_path, notice: "Creative approved."
  end

  def reject
    @ad_creative.update!(status: :rejected, rejection_reason: params[:reason])
    AuditLog.record!(action: "reject_ad_creative", metadata: { ad_creative_id: @ad_creative.id })
    redirect_to admin_ad_creatives_path, notice: "Creative rejected."
  end

  private
    def set_ad_creative
      @ad_creative = AdCreative.find(params[:id])
    end
end
