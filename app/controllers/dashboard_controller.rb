class DashboardController < ApplicationController
  def show
    @books = Current.account.books.accessable_or_published.ordered
  end
end
