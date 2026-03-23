class IssuesController < ApplicationController
  allow_unauthenticated_access

  def show
    @issue = Issue.find_by!(slug: params[:slug])
    @book = @issue.book
    @branding = @book.publication_branding

    renderer = IssueRenderer.new(book: @book, articles: @issue.articles)
    @html_content = renderer.render_html
  end
end
