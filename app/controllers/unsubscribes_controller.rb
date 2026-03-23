class UnsubscribesController < ApplicationController
  allow_unauthenticated_access

  before_action :set_subscriber

  # RFC 8058: One-click unsubscribe via GET
  def show
    @book = @subscriber.book
  end

  # RFC 8058: One-click unsubscribe via POST
  def create
    @subscriber.unsubscribe!
    @book = @subscriber.book

    redirect_to subscription_path(handle: @book.slug), notice: "You've been unsubscribed."
  end

  private
    def set_subscriber
      @subscriber = Subscriber.find_by!(unsubscribe_token: params[:token])
    end
end
