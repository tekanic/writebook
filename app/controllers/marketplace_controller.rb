class MarketplaceController < ApplicationController
  allow_unauthenticated_access

  def index
    @ad_slots = AdSlot.available.includes(:book).order(created_at: :desc)
  end
end
