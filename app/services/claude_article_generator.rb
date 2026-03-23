class ClaudeArticleGenerator
  DEFAULT_MODEL = "claude-haiku-4-5"

  def initialize(source_content:, source_title:, source_url:, model: DEFAULT_MODEL)
    @source_content = source_content
    @source_title = source_title
    @source_url = source_url
    @model = model
  end

  def generate
    chat = RubyLLM.chat(model: @model)

    response = chat.ask(prompt)

    title = extract_title(response.content)
    body = extract_body(response.content)
    attribution = build_attribution

    {
      success: true,
      title: title,
      body_markdown: body,
      attribution_html: attribution,
      ai_model_used: @model,
      input_tokens: response.input_tokens,
      output_tokens: response.output_tokens
    }
  rescue => e
    { success: false, error: e.message }
  end

  private
    def prompt
      <<~PROMPT
        You are a newsletter article writer. Based on the following source content, write an original newsletter article.

        Requirements:
        - Write in a clear, engaging newsletter style
        - The article should be 300-600 words
        - Include a compelling title on the first line prefixed with "# "
        - Use markdown formatting
        - Do NOT copy text verbatim from the source — rewrite in your own words
        - Add your own analysis or takeaways

        Source: #{@source_title}
        URL: #{@source_url}

        Content:
        #{@source_content.truncate(8000)}
      PROMPT
    end

    def extract_title(content)
      if content =~ /^#\s+(.+)$/
        $1.strip
      else
        content.lines.first&.strip&.gsub(/^#+\s*/, "") || "Untitled Article"
      end
    end

    def extract_body(content)
      # Remove the title line
      lines = content.lines
      lines.shift if lines.first&.match?(/^#\s+/)
      lines.join.strip
    end

    def build_attribution
      "<p><em>This article was generated with AI assistance based on " \
        "<a href=\"#{@source_url}\">#{@source_title}</a>. " \
        "AI-generated content may contain inaccuracies.</em></p>"
    end
end
