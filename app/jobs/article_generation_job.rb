class ArticleGenerationJob < ApplicationJob
  queue_as :ai

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(article_source)
    account = article_source.account

    # Check plan limits
    return unless account.can_generate_ai_article?

    # Fetch source content
    reader = JinaReader.new(article_source.url)
    result = reader.fetch
    return unless result[:success]

    # Generate article
    generator = AiArticleGenerator.new(
      source_content: result[:content],
      source_title: result[:title],
      source_url: article_source.url
    )
    article_result = generator.generate
    return unless article_result[:success]

    # Save generated article
    account.generated_articles.create!(
      article_source: article_source,
      title: article_result[:title],
      body_markdown: article_result[:body_markdown],
      attribution_html: article_result[:attribution_html],
      source_url: article_source.url,
      source_title: result[:title],
      ai_model_used: article_result[:ai_model_used],
      input_tokens: article_result[:input_tokens],
      output_tokens: article_result[:output_tokens]
    )
  end
end
