module PlanGated
  extend ActiveSupport::Concern

  private
    def enforce_publication_limit
      unless Current.account.can_add_publication?
        redirect_to root_path, alert: "You've reached your publication limit. Upgrade your plan to add more."
      end
    end

    def enforce_subscriber_limit
      unless Current.account.can_add_subscriber?
        redirect_to root_path, alert: "You've reached your subscriber limit. Upgrade your plan to add more."
      end
    end

    def enforce_custom_domain_limit
      unless Current.account.can_add_custom_domain?
        redirect_to root_path, alert: "Custom domains are available on the Grow plan and above."
      end
    end

    def enforce_ai_article_limit
      unless Current.account.can_generate_ai_article?
        redirect_to root_path, alert: "You've reached your AI article limit for this month."
      end
    end
end
