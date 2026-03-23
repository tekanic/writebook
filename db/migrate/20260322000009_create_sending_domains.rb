class CreateSendingDomains < ActiveRecord::Migration[8.0]
  def change
    create_table :sending_domains do |t|
      t.references :account, null: false, foreign_key: true
      t.string :domain, null: false
      t.string :status, null: false, default: "pending"
      t.json :dns_records, default: {}
      t.string :resend_domain_id
      t.integer :verification_attempts, default: 0
      t.timestamps
    end

    add_index :sending_domains, :domain, unique: true
  end
end
