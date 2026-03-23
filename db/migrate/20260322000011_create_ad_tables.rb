class CreateAdTables < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_slots do |t|
      t.references :book, null: false, foreign_key: true
      t.string :name, null: false
      t.string :position, null: false, default: "top"
      t.string :pricing_model, null: false, default: "flat"
      t.integer :price_cents, null: false, default: 0
      t.date :available_from
      t.date :available_to
      t.string :category_policy
      t.boolean :listed, default: true
      t.timestamps
    end

    create_table :ad_creatives do |t|
      t.references :advertiser, null: false, foreign_key: { to_table: :users }
      t.string :headline, null: false
      t.text :body_text, null: false
      t.string :destination_url, null: false
      t.string :cta_text, default: "Learn more"
      t.string :advertiser_name
      t.string :status, null: false, default: "pending"
      t.text :rejection_reason
      t.json :automated_check_results, default: {}
      t.timestamps
    end

    add_index :ad_creatives, :status

    create_table :ad_purchases do |t|
      t.references :ad_slot, null: false, foreign_key: true
      t.references :ad_creative, null: false, foreign_key: true
      t.references :issue, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.string :stripe_payment_intent_id
      t.string :stripe_checkout_session_id
      t.integer :amount_cents, null: false, default: 0
      t.timestamps
    end

    create_table :ad_clicks do |t|
      t.references :ad_creative, null: false, foreign_key: true
      t.references :delivery, foreign_key: true
      t.string :token, null: false
      t.string :ip_address
      t.string :user_agent
      t.timestamps
    end

    add_index :ad_clicks, :token, unique: true
  end
end
