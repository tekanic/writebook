class Books::BrandingsController < ApplicationController
  include BookScoped

  before_action :ensure_editable
  before_action :set_branding

  def edit
  end

  def update
    if @branding.update(branding_params)
      redirect_to book_slug_url(@book), notice: "Branding updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_branding
      @branding = @book.publication_branding || @book.build_publication_branding
    end

    def branding_params
      params.require(:publication_branding).permit(
        :accent_color, :from_name, :tagline, :footer_text,
        :font_family, :logo, :header_image, social_links: {}
      )
    end
end
