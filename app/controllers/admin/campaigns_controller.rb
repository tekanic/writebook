class Admin::CampaignsController < Admin::BaseController
  def index
    @campaigns = Campaign.order(created_at: :desc).includes(issue: :book).limit(50)
  end
end
