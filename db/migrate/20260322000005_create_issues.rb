class CreateIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :issues do |t|
      t.references :book, null: false, foreign_key: true
      t.string :subject, null: false
      t.string :preview_text
      t.string :status, null: false, default: "draft"
      t.string :slug
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.timestamps
    end

    add_index :issues, :slug, unique: true
    add_index :issues, :status
  end
end
