class AddPlatformAdminAndAuditLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :platform_admin, :boolean, default: false

    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :target_account, foreign_key: { to_table: :accounts }
      t.string :action, null: false
      t.json :metadata, default: {}
      t.string :ip_address
      t.timestamps
    end

    add_index :audit_logs, :action

    # Recurring campaigns
    add_column :issues, :recurring, :boolean, default: false
    add_column :issues, :cron_expression, :string
    add_column :issues, :last_recurring_send_at, :datetime
  end
end
