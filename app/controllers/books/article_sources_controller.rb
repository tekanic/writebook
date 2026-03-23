class Books::ArticleSourcesController < ApplicationController
  include BookScoped, PlanGated

  before_action :ensure_editable
  before_action :set_article_source, only: %i[show edit update destroy]

  def index
    @article_sources = Current.account.article_sources.order(created_at: :desc)
  end

  def new
    @article_source = ArticleSource.new
  end

  def create
    @article_source = Current.account.article_sources.build(article_source_params)

    if @article_source.save
      redirect_to book_article_sources_path(@book), notice: "Source added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @generated_articles = @article_source.generated_articles.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @article_source.update(article_source_params)
      redirect_to book_article_source_path(@book, @article_source), notice: "Source updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article_source.destroy
    redirect_to book_article_sources_path(@book), notice: "Source removed."
  end

  private
    def set_article_source
      @article_source = Current.account.article_sources.find(params[:id])
    end

    def article_source_params
      params.require(:article_source).permit(:url, :name, :fetch_frequency, :status)
    end
end
