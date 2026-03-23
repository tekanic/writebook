class Books::GeneratedArticlesController < ApplicationController
  include BookScoped, PlanGated

  before_action :ensure_editable
  before_action :set_generated_article, only: %i[show publish reject]

  def index
    @generated_articles = Current.account.generated_articles.order(created_at: :desc)
  end

  def show
  end

  def publish
    @generated_article.publish_to_book!(@book)
    redirect_to book_slug_path(@book), notice: "Article published to your publication."
  end

  def reject
    @generated_article.update!(status: :rejected)
    redirect_to book_generated_articles_path(@book), notice: "Article rejected."
  end

  private
    def set_generated_article
      @generated_article = Current.account.generated_articles.find(params[:id])
    end
end
