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

ActiveRecord::Schema[7.2].define(version: 2024_10_17_230019) do
  create_table "ahoy_events", force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.text "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.integer "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "connected_accounts", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.string "username"
    t.integer "user_id", null: false
    t.string "access_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_connected_accounts_on_provider_and_uid", unique: true
    t.index ["provider", "username"], name: "index_connected_accounts_on_provider_and_username", unique: true
    t.index ["user_id"], name: "index_connected_accounts_on_user_id"
  end

  create_table "email_verification_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_email_verification_tokens_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.date "date"
    t.string "city"
    t.string "country_code"
    t.integer "organisation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.integer "talks_count", default: 0, null: false
    t.integer "canonical_id"
    t.index ["canonical_id"], name: "index_events_on_canonical_id"
    t.index ["name"], name: "index_events_on_name"
    t.index ["organisation_id"], name: "index_events_on_organisation_id"
    t.index ["slug"], name: "index_events_on_slug"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.string "website", default: "", null: false
    t.integer "kind", default: 0, null: false
    t.integer "frequency", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_channel_id", default: "", null: false
    t.string "youtube_channel_name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "twitter", default: "", null: false
    t.string "language", default: "", null: false
    t.index ["frequency"], name: "index_organisations_on_frequency"
    t.index ["kind"], name: "index_organisations_on_kind"
    t.index ["name"], name: "index_organisations_on_name"
    t.index ["slug"], name: "index_organisations_on_slug"
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_password_reset_tokens_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "speaker_talks", force: :cascade do |t|
    t.integer "speaker_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speaker_id", "talk_id"], name: "index_speaker_talks_on_speaker_id_and_talk_id", unique: true
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "twitter", default: "", null: false
    t.string "github", default: "", null: false
    t.text "bio", default: "", null: false
    t.string "website", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "talks_count", default: 0, null: false
    t.integer "canonical_id"
    t.index ["canonical_id"], name: "index_speakers_on_canonical_id"
    t.index ["name"], name: "index_speakers_on_name"
    t.index ["slug"], name: "index_speakers_on_slug", unique: true
  end

  create_table "suggestions", force: :cascade do |t|
    t.text "content"
    t.integer "status", default: 0, null: false
    t.string "suggestable_type", null: false
    t.integer "suggestable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approved_by_id"
    t.integer "suggested_by_id"
    t.index ["approved_by_id"], name: "index_suggestions_on_approved_by_id"
    t.index ["status"], name: "index_suggestions_on_status"
    t.index ["suggestable_type", "suggestable_id"], name: "index_suggestions_on_suggestable"
    t.index ["suggested_by_id"], name: "index_suggestions_on_suggested_by_id"
  end

  create_table "talk_topics", force: :cascade do |t|
    t.integer "talk_id", null: false
    t.integer "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id", "topic_id"], name: "index_talk_topics_on_talk_id_and_topic_id", unique: true
    t.index ["talk_id"], name: "index_talk_topics_on_talk_id"
    t.index ["topic_id"], name: "index_talk_topics_on_topic_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.text "description", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "video_id", default: "", null: false
    t.string "video_provider", default: "", null: false
    t.string "thumbnail_sm", default: "", null: false
    t.string "thumbnail_md", default: "", null: false
    t.string "thumbnail_lg", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.string "thumbnail_xs", default: "", null: false
    t.string "thumbnail_xl", default: "", null: false
    t.date "date"
    t.integer "like_count"
    t.integer "view_count"
    t.text "raw_transcript", default: "", null: false
    t.text "enhanced_transcript", default: "", null: false
    t.text "summary", default: "", null: false
    t.string "language", default: "en", null: false
    t.string "slides_url"
    t.boolean "embedded", default: false
    t.index ["date"], name: "index_talks_on_date"
    t.index ["event_id"], name: "index_talks_on_event_id"
    t.index ["slug"], name: "index_talks_on_slug"
    t.index ["title"], name: "index_talks_on_title"
    t.index ["updated_at"], name: "index_talks_on_updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "published", default: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.integer "canonical_id"
    t.integer "talks_count"
    t.index ["canonical_id"], name: "index_topics_on_canonical_id"
    t.index ["name"], name: "index_topics_on_name", unique: true
    t.index ["status"], name: "index_topics_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "github_handle"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_handle"], name: "index_users_on_github_handle", unique: true, where: "github_handle IS NOT NULL"
  end

  create_table "watch_list_talks", force: :cascade do |t|
    t.integer "watch_list_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_watch_list_talks_on_talk_id"
    t.index ["watch_list_id", "talk_id"], name: "index_watch_list_talks_on_watch_list_id_and_talk_id", unique: true
    t.index ["watch_list_id"], name: "index_watch_list_talks_on_watch_list_id"
  end

  create_table "watch_lists", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "talks_count", default: 0
    t.index ["user_id"], name: "index_watch_lists_on_user_id"
  end

  add_foreign_key "connected_accounts", "users"
  add_foreign_key "email_verification_tokens", "users"
  add_foreign_key "events", "events", column: "canonical_id"
  add_foreign_key "events", "organisations"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "speakers", "speakers", column: "canonical_id"
  add_foreign_key "suggestions", "users", column: "approved_by_id"
  add_foreign_key "suggestions", "users", column: "suggested_by_id"
  add_foreign_key "talk_topics", "talks"
  add_foreign_key "talk_topics", "topics"
  add_foreign_key "talks", "events"
  add_foreign_key "topics", "topics", column: "canonical_id"
  add_foreign_key "watch_list_talks", "talks"
  add_foreign_key "watch_list_talks", "watch_lists"
end
