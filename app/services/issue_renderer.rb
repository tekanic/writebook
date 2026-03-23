class IssueRenderer
  attr_reader :book, :branding, :articles

  def initialize(book:, articles: [])
    @book = book
    @branding = book.publication_branding
    @articles = articles
  end

  def render_html
    markdown_content = articles.map { |article| article_to_markdown(article) }.join("\n\n---\n\n")
    html_body = render_markdown(markdown_content)
    html_body
  end

  def render_text
    articles.map { |article| article_to_text(article) }.join("\n\n---\n\n")
  end

  private
    def article_to_markdown(article)
      case article
      when Page
        "## #{article.title}\n\n#{article.body.content}"
      when Section
        "# #{article.title}\n\n#{article.body}"
      else
        "## #{article.title}"
      end
    end

    def article_to_text(article)
      case article
      when Page
        "#{article.title}\n#{"=" * article.title.length}\n\n#{strip_markdown(article.body.content)}"
      when Section
        "#{article.title}\n#{"=" * article.title.length}\n\n#{article.body}"
      else
        article.title
      end
    end

    def render_markdown(content)
      renderer = Redcarpet::Render::HTML.new(ActionText::Markdown::DEFAULT_RENDERER_OPTIONS)
      markdown = Redcarpet::Markdown.new(renderer, ActionText::Markdown::DEFAULT_MARKDOWN_EXTENSIONS)
      markdown.render(content.to_s)
    end

    def strip_markdown(text)
      text.to_s
        .gsub(/\[([^\]]+)\]\([^)]+\)/, '\1')
        .gsub(/[*_~`#]/, "")
        .gsub(/!\[([^\]]*)\]\([^)]+\)/, '\1')
        .strip
    end
end
