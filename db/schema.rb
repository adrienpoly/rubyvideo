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

ActiveRecord::Schema[7.1].define(version: 2023_07_20_151537) do
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
    t.index ["status"], name: "index_suggestions_on_status"
    t.index ["suggestable_type", "suggestable_id"], name: "index_suggestions_on_suggestable"
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
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.string "thumbnail_xs", default: "", null: false
    t.string "thumbnail_xl", default: "", null: false
    t.date "date"
    t.integer "like_count"
    t.integer "view_count"
    t.index ["date"], name: "index_talks_on_date"
    t.index ["event_id"], name: "index_talks_on_event_id"
    t.index ["slug"], name: "index_talks_on_slug"
    t.index ["title"], name: "index_talks_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.boolean "verified", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "email_verification_tokens", "users"
  add_foreign_key "events", "organisations"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "talks", "events"
end
