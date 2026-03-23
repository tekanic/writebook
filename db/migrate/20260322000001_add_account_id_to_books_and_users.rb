class AddAccountIdToBooksAndUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :account_id, :integer
    add_column :users, :account_id, :integer

    add_index :books, :account_id
    add_index :users, :account_id

    add_foreign_key :books, :accounts
    add_foreign_key :users, :accounts

    add_column :accounts, :subdomain, :string
    add_index :accounts, :subdomain, unique: true
  end
end
