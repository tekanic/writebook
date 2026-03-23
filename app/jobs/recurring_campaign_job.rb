class RecurringCampaignJob < ApplicationJob
  queue_as :email

  def perform
    Issue.where(recurring: true).find_each do |issue|
      next unless should_send?(issue)

      book = issue.book
      # Only send if there's new content since last send
      last_send = issue.last_recurring_send_at || issue.created_at
      new_leaves = book.leaves.active.where("updated_at > ?", last_send)
      next unless new_leaves.any?

      campaign = issue.campaigns.create!(status: :pending)
      book.subscribers.deliverable.find_each do |subscriber|
        campaign.deliveries.create!(subscriber: subscriber)
      end
      campaign.dispatch!

      issue.update!(last_recurring_send_at: Time.current, sent_at: Time.current)
    end
  end

  private
    def should_send?(issue)
      return false unless issue.cron_expression.present?
      # Simple frequency check — weekly on Monday
      case issue.cron_expression
      when "weekly"
        Time.current.monday? && (issue.last_recurring_send_at.nil? || issue.last_recurring_send_at < 6.days.ago)
      when "daily"
        issue.last_recurring_send_at.nil? || issue.last_recurring_send_at < 23.hours.ago
      else
        false
      end
    end
end
