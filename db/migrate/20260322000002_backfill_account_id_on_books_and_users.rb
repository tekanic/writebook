class BackfillAccountIdOnBooksAndUsers < ActiveRecord::Migration[8.0]
  def up
    account_id = execute("SELECT id FROM accounts LIMIT 1").first&.fetch("id")
    return unless account_id

    execute("UPDATE books SET account_id = #{account_id} WHERE account_id IS NULL")
    execute("UPDATE users SET account_id = #{account_id} WHERE account_id IS NULL")
  end

  def down
    execute("UPDATE books SET account_id = NULL")
    execute("UPDATE users SET account_id = NULL")
  end
end
