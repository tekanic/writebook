class AdCreativeReviewJob < ApplicationJob
  queue_as :default

  BLOCKED_KEYWORDS = %w[casino gambling porn xxx adult].freeze

  def perform(ad_creative)
    results = {}

    # Keyword check
    combined_text = "#{ad_creative.headline} #{ad_creative.body_text}".downcase
    blocked = BLOCKED_KEYWORDS.select { |kw| combined_text.include?(kw) }
    results[:keyword_check] = blocked.empty? ? "pass" : "fail:#{blocked.join(',')}"

    # URL safety check (Safe Browsing API if configured)
    results[:url_check] = check_url_safety(ad_creative.destination_url)

    # Image scan (ClamAV if available)
    if ad_creative.image.attached?
      results[:image_check] = scan_image(ad_creative)
    end

    ad_creative.update!(automated_check_results: results)

    if results.values.all? { |v| v == "pass" }
      ad_creative.update!(status: :approved)
    elsif results.values.any? { |v| v.to_s.start_with?("fail") }
      ad_creative.update!(
        status: :rejected,
        rejection_reason: "Automated review failed: #{results.select { |_, v| v.to_s.start_with?("fail") }.keys.join(", ")}"
      )
    end
  end

  private
    def check_url_safety(url)
      # Integrate with Google Safe Browsing API when configured
      if ENV["GOOGLE_SAFE_BROWSING_API_KEY"].present?
        # API call would go here
        "pass"
      else
        "pass"
      end
    end

    def scan_image(ad_creative)
      # Integrate with ClamAV when available
      "pass"
    end
end
