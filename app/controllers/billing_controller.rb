class BillingController < ApplicationController
  before_action :ensure_can_administer

  def show
    @account = Current.account
  end

  def create_checkout
    # Stripe Checkout session creation
    price_id = case params[:plan]
    when "grow" then ENV["STRIPE_GROW_PRICE_ID"]
    when "scale" then ENV["STRIPE_SCALE_PRICE_ID"]
    else
      redirect_to billing_path, alert: "Invalid plan."
      return
    end

    session = Stripe::Checkout::Session.create(
      customer: Current.account.stripe_customer_id,
      payment_method_types: ["card"],
      line_items: [{ price: price_id, quantity: 1 }],
      mode: "subscription",
      success_url: billing_url(upgraded: true),
      cancel_url: billing_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def portal
    session = Stripe::BillingPortal::Session.create(
      customer: Current.account.stripe_customer_id,
      return_url: billing_url
    )

    redirect_to session.url, allow_other_host: true
  end
end
