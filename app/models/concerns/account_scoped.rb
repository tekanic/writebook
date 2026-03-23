module AccountScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :account
    scope :for_account, ->(account = Current.account) { where(account: account) }
  end
end
