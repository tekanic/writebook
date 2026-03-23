module VocabularyHelper
  def publication_label(count = 1)
    count == 1 ? "Publication" : "Publications"
  end

  def article_label(count = 1)
    count == 1 ? "Article" : "Articles"
  end

  def issue_label(count = 1)
    count == 1 ? "Issue" : "Issues"
  end

  def subscriber_label(count = 1)
    count == 1 ? "Subscriber" : "Subscribers"
  end

  def library_label
    "My Publications"
  end

  def product_name
    "BookSend"
  end
end
