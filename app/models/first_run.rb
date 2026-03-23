class FirstRun
  ACCOUNT_NAME = "BookSend"

  def self.create!(user_params)
    account = Account.create!(name: ACCOUNT_NAME)

    User.create!(user_params.merge(role: :administrator, account: account)).tap do |user|
      DemoContent.create_manual(user)
    end
  end
end
