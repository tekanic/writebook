class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.references :issue, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.integer :sent_count, default: 0
      t.integer :failed_count, default: 0
      t.integer :open_count, default: 0
      t.integer :click_count, default: 0
      t.integer :bounce_count, default: 0
      t.integer :unsubscribe_count, default: 0
      t.timestamps
    end
  end
end
