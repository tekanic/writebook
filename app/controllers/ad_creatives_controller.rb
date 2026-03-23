class AdCreativesController < ApplicationController
  before_action :set_ad_creative, only: %i[show edit update]

  def index
    @ad_creatives = AdCreative.where(advertiser: Current.user).order(created_at: :desc)
  end

  def new
    @ad_creative = AdCreative.new
  end

  def create
    @ad_creative = Current.user.ad_creatives.build(ad_creative_params)

    if @ad_creative.save
      redirect_to ad_creative_path(@ad_creative), notice: "Creative submitted for review."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @ad_creative.pending? && @ad_creative.update(ad_creative_params)
      redirect_to ad_creative_path(@ad_creative), notice: "Creative updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_ad_creative
      @ad_creative = AdCreative.where(advertiser: Current.user).find(params[:id])
    end

    def ad_creative_params
      params.require(:ad_creative).permit(:headline, :body_text, :destination_url, :cta_text, :advertiser_name, :image)
    end
end
