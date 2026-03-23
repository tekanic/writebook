class SubscriberImportJob < ApplicationJob
  queue_as :imports

  def perform(book_id, csv_data, email_column: 0)
    book = Book.find(book_id)
    require "csv"

    rows = CSV.parse(csv_data, headers: true)
    email_header = rows.headers[email_column]

    rows.each_slice(100) do |batch|
      records = batch.filter_map do |row|
        email = row[email_header]&.downcase&.strip
        next if email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)

        {
          book_id: book.id,
          email_address: email,
          status: "active",
          unsubscribe_token: SecureRandom.base58(24),
          source: "csv_import",
          consent_timestamp: Time.current,
          confirmed_at: Time.current,
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      Subscriber.upsert_all(records, unique_by: [:book_id, :email_address]) if records.any?
    end
  end
end
