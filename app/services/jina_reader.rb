class JinaReader
  BASE_URL = "https://r.jina.ai"

  def initialize(url)
    @url = url
  end

  def fetch
    uri = URI("#{BASE_URL}/#{@url}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      { success: true, content: response.body, title: extract_title(response.body) }
    else
      { success: false, error: "HTTP #{response.code}" }
    end
  rescue => e
    { success: false, error: e.message }
  end

  private
    def extract_title(content)
      if content =~ /^#\s+(.+)$/
        $1.strip
      else
        content.lines.first&.strip || "Untitled"
      end
    end
end
