class Books::AdSlotsController < ApplicationController
  include BookScoped

  before_action :ensure_editable
  before_action :set_ad_slot, only: %i[edit update destroy]

  def index
    @ad_slots = @book.ad_slots
  end

  def new
    @ad_slot = @book.ad_slots.build
  end

  def create
    @ad_slot = @book.ad_slots.build(ad_slot_params)

    if @ad_slot.save
      redirect_to book_ad_slots_path(@book), notice: "Ad slot created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ad_slot.update(ad_slot_params)
      redirect_to book_ad_slots_path(@book), notice: "Ad slot updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ad_slot.destroy
    redirect_to book_ad_slots_path(@book), notice: "Ad slot removed."
  end

  private
    def set_ad_slot
      @ad_slot = @book.ad_slots.find(params[:id])
    end

    def ad_slot_params
      params.require(:ad_slot).permit(:name, :position, :pricing_model, :price_cents, :available_from, :available_to, :category_policy, :listed)
    end
end
