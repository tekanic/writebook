module PlanEnforceable
  extend ActiveSupport::Concern

  PLANS = {
    "seed" => { subscriber_limit: 500, publication_limit: 1, ai_article_limit: 0, custom_domain: false },
    "grow" => { subscriber_limit: 5_000, publication_limit: 5, ai_article_limit: 10, custom_domain: true },
    "scale" => { subscriber_limit: 50_000, publication_limit: 25, ai_article_limit: 50, custom_domain: true }
  }.freeze

  def plan_config
    PLANS[plan] || PLANS["seed"]
  end

  def can_add_subscriber?
    total_subscribers < (subscriber_limit || plan_config[:subscriber_limit])
  end

  def can_add_publication?
    books.count < (publication_limit || plan_config[:publication_limit])
  end

  def can_generate_ai_article?
    monthly_ai_articles < (ai_article_limit || plan_config[:ai_article_limit])
  end

  def can_add_custom_domain?
    plan_config[:custom_domain]
  end

  def trial_active?
    trial_ends_at.present? && trial_ends_at > Time.current
  end

  def trial_expired?
    trial_ends_at.present? && trial_ends_at <= Time.current
  end

  private
    def total_subscribers
      books.joins(:subscribers).where(subscribers: { status: :active }).count
    end

    def monthly_ai_articles
      generated_articles.where("created_at >= ?", Time.current.beginning_of_month).count
    end
end
