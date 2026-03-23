class CreateAiTables < ActiveRecord::Migration[8.0]
  def change
    create_table :article_sources do |t|
      t.references :account, null: false, foreign_key: true
      t.string :url, null: false
      t.string :name, null: false
      t.string :fetch_frequency, null: false, default: "daily"
      t.string :status, null: false, default: "active"
      t.datetime :last_fetched_at
      t.timestamps
    end

    create_table :generated_articles do |t|
      t.references :article_source, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :page, foreign_key: true
      t.string :title, null: false
      t.text :body_markdown, null: false
      t.text :attribution_html, null: false
      t.string :source_url
      t.string :source_title
      t.string :status, null: false, default: "pending"
      t.string :ai_model_used
      t.integer :input_tokens, default: 0
      t.integer :output_tokens, default: 0
      t.timestamps
    end

    add_index :generated_articles, :status
  end
end
