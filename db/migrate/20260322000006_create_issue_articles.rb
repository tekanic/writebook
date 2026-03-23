class CreateIssueArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :issue_articles do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :leaf, null: false, foreign_key: true
      t.float :position_score, null: false, default: 0
      t.timestamps
    end

    add_index :issue_articles, [:issue_id, :leaf_id], unique: true
  end
end
