class AddPlanFieldsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :plan, :string, default: "seed", null: false
    add_column :accounts, :subscriber_limit, :integer, default: 500
    add_column :accounts, :publication_limit, :integer, default: 3
    add_column :accounts, :ai_article_limit, :integer, default: 0
    add_column :accounts, :trial_ends_at, :datetime
    add_column :accounts, :stripe_customer_id, :string
    add_column :accounts, :stripe_connect_account_id, :string
  end
end
