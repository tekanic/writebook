class CreateDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :deliveries do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :subscriber, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.string :resend_message_id
      t.datetime :sent_at
      t.datetime :opened_at
      t.datetime :clicked_at
      t.datetime :bounced_at
      t.timestamps
    end

    add_index :deliveries, [:campaign_id, :subscriber_id], unique: true
    add_index :deliveries, :resend_message_id
  end
end
