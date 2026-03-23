class CreateSubscribers < ActiveRecord::Migration[8.0]
  def change
    create_table :subscribers do |t|
      t.references :book, null: false, foreign_key: true
      t.string :email_address, null: false
      t.string :status, null: false, default: "pending"
      t.string :confirmation_token
      t.string :unsubscribe_token, null: false
      t.string :source
      t.datetime :consent_timestamp
      t.datetime :confirmed_at
      t.timestamps
    end

    add_index :subscribers, [:book_id, :email_address], unique: true
    add_index :subscribers, :confirmation_token, unique: true
    add_index :subscribers, :unsubscribe_token, unique: true
    add_index :subscribers, :status
  end
end
