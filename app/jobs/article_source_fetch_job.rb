class ArticleSourceFetchJob < ApplicationJob
  queue_as :ai

  def perform
    ArticleSource.due_for_fetch.find_each do |source|
      ArticleGenerationJob.perform_later(source)
      source.update!(last_fetched_at: Time.current)
    end
  end
end
