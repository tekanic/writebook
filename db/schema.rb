# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.2].define(version: 2026_03_22_000013) do
  create_table "accesses", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.string "level", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["book_id"], name: "index_accesses_on_book_id"
    t.index ["user_id", "book_id"], name: "index_accesses_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "ai_article_limit", default: 0
    t.datetime "created_at", null: false
    t.text "custom_styles"
    t.string "join_code", null: false
    t.string "name", null: false
    t.string "plan", default: "seed", null: false
    t.integer "publication_limit", default: 3
    t.string "stripe_connect_account_id"
    t.string "stripe_customer_id"
    t.string "subdomain"
    t.integer "subscriber_limit", default: 500
    t.datetime "trial_ends_at"
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
  end

  create_table "action_text_markdowns", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_action_text_markdowns_on_record"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.string "slug"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["slug"], name: "index_active_storage_attachments_on_slug", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ad_clicks", force: :cascade do |t|
    t.integer "ad_creative_id", null: false
    t.datetime "created_at", null: false
    t.integer "delivery_id"
    t.string "ip_address"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["ad_creative_id"], name: "index_ad_clicks_on_ad_creative_id"
    t.index ["delivery_id"], name: "index_ad_clicks_on_delivery_id"
    t.index ["token"], name: "index_ad_clicks_on_token", unique: true
  end

  create_table "ad_creatives", force: :cascade do |t|
    t.integer "advertiser_id", null: false
    t.string "advertiser_name"
    t.json "automated_check_results", default: {}
    t.text "body_text", null: false
    t.datetime "created_at", null: false
    t.string "cta_text", default: "Learn more"
    t.string "destination_url", null: false
    t.string "headline", null: false
    t.text "rejection_reason"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["advertiser_id"], name: "index_ad_creatives_on_advertiser_id"
    t.index ["status"], name: "index_ad_creatives_on_status"
  end

  create_table "ad_purchases", force: :cascade do |t|
    t.integer "ad_creative_id", null: false
    t.integer "ad_slot_id", null: false
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "issue_id"
    t.string "status", default: "pending", null: false
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.datetime "updated_at", null: false
    t.index ["ad_creative_id"], name: "index_ad_purchases_on_ad_creative_id"
    t.index ["ad_slot_id"], name: "index_ad_purchases_on_ad_slot_id"
    t.index ["issue_id"], name: "index_ad_purchases_on_issue_id"
  end

  create_table "ad_slots", force: :cascade do |t|
    t.date "available_from"
    t.date "available_to"
    t.integer "book_id", null: false
    t.string "category_policy"
    t.datetime "created_at", null: false
    t.boolean "listed", default: true
    t.string "name", null: false
    t.string "position", default: "top", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "pricing_model", default: "flat", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_ad_slots_on_book_id"
  end

  create_table "article_sources", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "fetch_frequency", default: "daily", null: false
    t.datetime "last_fetched_at"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["account_id"], name: "index_article_sources_on_account_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.json "metadata", default: {}
    t.integer "target_account_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["target_account_id"], name: "index_audit_logs_on_target_account_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.integer "account_id"
    t.string "author"
    t.datetime "created_at", null: false
    t.boolean "everyone_access", default: true, null: false
    t.boolean "published", default: false, null: false
    t.string "slug", null: false
    t.string "subtitle"
    t.string "theme", default: "blue", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_books_on_account_id"
    t.index ["published"], name: "index_books_on_published"
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer "bounce_count", default: 0
    t.integer "click_count", default: 0
    t.datetime "created_at", null: false
    t.integer "failed_count", default: 0
    t.integer "issue_id", null: false
    t.integer "open_count", default: 0
    t.integer "sent_count", default: 0
    t.string "status", default: "pending", null: false
    t.integer "unsubscribe_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_campaigns_on_issue_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.datetime "bounced_at"
    t.integer "campaign_id", null: false
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.datetime "opened_at"
    t.string "resend_message_id"
    t.datetime "sent_at"
    t.string "status", default: "pending", null: false
    t.integer "subscriber_id", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "subscriber_id"], name: "index_deliveries_on_campaign_id_and_subscriber_id", unique: true
    t.index ["campaign_id"], name: "index_deliveries_on_campaign_id"
    t.index ["resend_message_id"], name: "index_deliveries_on_resend_message_id"
    t.index ["subscriber_id"], name: "index_deliveries_on_subscriber_id"
  end

  create_table "edits", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.integer "leaf_id", null: false
    t.integer "leafable_id", null: false
    t.string "leafable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["leaf_id"], name: "index_edits_on_leaf_id"
    t.index ["leafable_type", "leafable_id"], name: "index_edits_on_leafable"
  end

  create_table "generated_articles", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "ai_model_used"
    t.integer "article_source_id", null: false
    t.text "attribution_html", null: false
    t.text "body_markdown", null: false
    t.datetime "created_at", null: false
    t.integer "input_tokens", default: 0
    t.integer "output_tokens", default: 0
    t.integer "page_id"
    t.string "source_title"
    t.string "source_url"
    t.string "status", default: "pending", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_generated_articles_on_account_id"
    t.index ["article_source_id"], name: "index_generated_articles_on_article_source_id"
    t.index ["page_id"], name: "index_generated_articles_on_page_id"
    t.index ["status"], name: "index_generated_articles_on_status"
  end

  create_table "issue_articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "issue_id", null: false
    t.integer "leaf_id", null: false
    t.float "position_score", default: 0.0, null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "leaf_id"], name: "index_issue_articles_on_issue_id_and_leaf_id", unique: true
    t.index ["issue_id"], name: "index_issue_articles_on_issue_id"
    t.index ["leaf_id"], name: "index_issue_articles_on_leaf_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.string "cron_expression"
    t.datetime "last_recurring_send_at"
    t.string "preview_text"
    t.boolean "recurring", default: false
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.string "slug"
    t.string "status", default: "draft", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_issues_on_book_id"
    t.index ["slug"], name: "index_issues_on_slug", unique: true
    t.index ["status"], name: "index_issues_on_status"
  end

  create_table "leaves", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.integer "leafable_id", null: false
    t.string "leafable_type", null: false
    t.float "position_score", null: false
    t.string "status", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_leaves_on_book_id"
    t.index ["leafable_type", "leafable_id"], name: "index_leafs_on_leafable"
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publication_brandings", force: :cascade do |t|
    t.string "accent_color", default: "#0066cc"
    t.integer "book_id", null: false
    t.datetime "created_at", null: false
    t.string "font_family", default: "Arial"
    t.text "footer_text"
    t.string "from_name"
    t.json "social_links", default: {}
    t.string "tagline"
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_publication_brandings_on_book_id", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "theme"
    t.datetime "updated_at", null: false
  end

  create_table "sending_domains", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.json "dns_records", default: {}
    t.string "domain", null: false
    t.string "resend_domain_id"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.integer "verification_attempts", default: 0
    t.index ["account_id"], name: "index_sending_domains_on_account_id"
    t.index ["domain"], name: "index_sending_domains_on_domain", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "last_active_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.integer "book_id", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "consent_timestamp"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "source"
    t.string "status", default: "pending", null: false
    t.string "unsubscribe_token", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "email_address"], name: "index_subscribers_on_book_id_and_email_address", unique: true
    t.index ["book_id"], name: "index_subscribers_on_book_id"
    t.index ["confirmation_token"], name: "index_subscribers_on_confirmation_token", unique: true
    t.index ["status"], name: "index_subscribers_on_status"
    t.index ["unsubscribe_token"], name: "index_subscribers_on_unsubscribe_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.boolean "platform_admin", default: false
    t.integer "role", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "accesses", "books"
  add_foreign_key "accesses", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ad_clicks", "ad_creatives"
  add_foreign_key "ad_clicks", "deliveries"
  add_foreign_key "ad_creatives", "users", column: "advertiser_id"
  add_foreign_key "ad_purchases", "ad_creatives"
  add_foreign_key "ad_purchases", "ad_slots"
  add_foreign_key "ad_purchases", "issues"
  add_foreign_key "ad_slots", "books"
  add_foreign_key "article_sources", "accounts"
  add_foreign_key "audit_logs", "accounts", column: "target_account_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "books", "accounts"
  add_foreign_key "campaigns", "issues"
  add_foreign_key "deliveries", "campaigns"
  add_foreign_key "deliveries", "subscribers"
  add_foreign_key "edits", "leaves"
  add_foreign_key "generated_articles", "accounts"
  add_foreign_key "generated_articles", "article_sources"
  add_foreign_key "generated_articles", "pages"
  add_foreign_key "issue_articles", "issues"
  add_foreign_key "issue_articles", "leaves"
  add_foreign_key "issues", "books"
  add_foreign_key "leaves", "books"
  add_foreign_key "publication_brandings", "books"
  add_foreign_key "sending_domains", "accounts"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscribers", "books"
  add_foreign_key "users", "accounts"

  # Virtual tables defined in this database.
  # Note that virtual tables may not work with other database engines. Be careful if changing database.
  create_virtual_table "leaf_search_index", "fts5", ["title", "content", "tokenize='porter'"]
end
