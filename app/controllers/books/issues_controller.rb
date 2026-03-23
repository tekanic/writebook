class Books::IssuesController < ApplicationController
  include BookScoped

  before_action :ensure_editable
  before_action :set_issue, only: %i[show edit update destroy send_campaign]

  def index
    @issues = @book.issues.ordered
  end

  def new
    @issue = @book.issues.build
    @available_leaves = @book.leaves.active.positioned.with_leafables
  end

  def create
    @issue = @book.issues.build(issue_params)

    if @issue.save
      update_issue_articles
      redirect_to book_issue_path(@book, @issue)
    else
      @available_leaves = @book.leaves.active.positioned.with_leafables
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @available_leaves = @book.leaves.active.positioned.with_leafables
  end

  def update
    if @issue.update(issue_params)
      update_issue_articles
      redirect_to book_issue_path(@book, @issue)
    else
      @available_leaves = @book.leaves.active.positioned.with_leafables
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    redirect_to book_issues_path(@book)
  end

  def send_campaign
    campaign = @issue.campaigns.create!(status: :pending)

    @book.subscribers.deliverable.find_each do |subscriber|
      campaign.deliveries.create!(subscriber: subscriber)
    end

    campaign.dispatch!

    redirect_to book_issue_path(@book, @issue), notice: "Campaign is being sent."
  end

  private
    def set_issue
      @issue = @book.issues.find(params[:id])
    end

    def issue_params
      params.require(:issue).permit(:subject, :preview_text, :scheduled_at)
    end

    def update_issue_articles
      return unless params[:article_ids].present?

      @issue.issue_articles.destroy_all
      params[:article_ids].each_with_index do |leaf_id, index|
        @issue.issue_articles.create!(leaf_id: leaf_id, position_score: index + 1)
      end
    end
end
