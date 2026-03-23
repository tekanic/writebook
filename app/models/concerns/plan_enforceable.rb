module PlanEnforceable
  extend ActiveSupport::Concern

  PLANS = {
    "seed" => { subscriber_limit: 500, publication_limit: 3, ai_article_limit: 0, custom_domain: false },
    "grow" => { subscriber_limit: 5_000, publication_limit: 10, ai_article_limit: 10, custom_domain: true },
    "scale" => { subscriber_limit: 50_000, publication_limit: 50, ai_article_limit: 50, custom_domain: true }
  }.freeze

  def plan_config
    plan_name = has_attribute?(:plan) ? plan : "seed"
    PLANS[plan_name] || PLANS["seed"]
  end

  def can_add_subscriber?
    limit = has_attribute?(:subscriber_limit) && subscriber_limit.present? ? subscriber_limit : plan_config[:subscriber_limit]
    total_subscribers < limit
  end

  def can_add_publication?
    limit = has_attribute?(:publication_limit) && publication_limit.present? ? publication_limit : plan_config[:publication_limit]
    books.count < limit
  end

  def can_generate_ai_article?
    limit = has_attribute?(:ai_article_limit) && ai_article_limit.present? ? ai_article_limit : plan_config[:ai_article_limit]
    monthly_ai_articles < limit
  end

  def can_add_custom_domain?
    plan_config[:custom_domain]
  end

  def trial_active?
    has_attribute?(:trial_ends_at) && trial_ends_at.present? && trial_ends_at > Time.current
  end

  def trial_expired?
    has_attribute?(:trial_ends_at) && trial_ends_at.present? && trial_ends_at <= Time.current
  end

  private
    def total_subscribers
      return 0 unless respond_to?(:books)
      books.joins(:subscribers).where(subscribers: { status: :active }).count
    rescue ActiveRecord::StatementInvalid
      0
    end

    def monthly_ai_articles
      return 0 unless respond_to?(:generated_articles)
      generated_articles.where("created_at >= ?", Time.current.beginning_of_month).count
    rescue ActiveRecord::StatementInvalid
      0
    end
end
