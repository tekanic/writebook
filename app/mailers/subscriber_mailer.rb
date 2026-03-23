class SubscriberMailer < ApplicationMailer
  def confirmation_email(subscriber)
    @subscriber = subscriber
    @book = subscriber.book
    @confirmation_url = confirm_subscription_url(
      handle: @book.slug,
      token: subscriber.confirmation_token
    )

    mail(
      to: subscriber.email_address,
      subject: "Confirm your subscription to #{@book.title}"
    )
  end

  def unsubscribe_confirmation(subscriber)
    @subscriber = subscriber
    @book = subscriber.book

    mail(
      to: subscriber.email_address,
      subject: "You've been unsubscribed from #{@book.title}"
    )
  end
end
