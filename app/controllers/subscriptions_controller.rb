class SubscriptionsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_book

  def show
  end

  def create
    @subscriber = @book.subscribers.find_or_initialize_by(
      email_address: subscriber_params[:email_address].downcase.strip
    )

    if @subscriber.new_record?
      @subscriber.source = "web"
      @subscriber.consent_timestamp = Time.current
      @subscriber.save!
      SubscriberMailer.confirmation_email(@subscriber).deliver_later
    elsif @subscriber.unsubscribed?
      @subscriber.update!(status: :pending)
      @subscriber.regenerate_confirmation_token
      SubscriberMailer.confirmation_email(@subscriber).deliver_later
    end

    redirect_to subscription_path(handle: @book.slug), notice: "Check your email to confirm your subscription."
  rescue ActiveRecord::RecordInvalid
    redirect_to subscription_path(handle: @book.slug), alert: "Please enter a valid email address."
  end

  def confirm
    @subscriber = Subscriber.find_by!(confirmation_token: params[:token])

    if @subscriber.confirmation_expired?
      redirect_to subscription_path(handle: @subscriber.book.slug), alert: "This confirmation link has expired. Please subscribe again."
    else
      @subscriber.confirm!
      redirect_to subscription_path(handle: @subscriber.book.slug), notice: "You're subscribed!"
    end
  end

  private
    def set_book
      @book = Book.find_by!(slug: params[:handle])
    end

    def subscriber_params
      params.require(:subscriber).permit(:email_address)
    end
end
