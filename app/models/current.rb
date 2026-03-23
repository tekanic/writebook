class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user, :account

  def session=(value)
    super(value)

    if value.present?
      self.user = session.user
      self.account = user&.account
    end
  end

  def account
    super || Account.first
  end
end
