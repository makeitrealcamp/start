# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_01_11_222739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activity_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_id"
    t.string "activity_type"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_type", "activity_id"], name: "index_activity_logs_on_activity_type_and_activity_id"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", limit: 100
    t.string "password_digest"
    t.text "permissions", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applicant_activities", id: :serial, force: :cascade do |t|
    t.integer "applicant_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "info"
    t.string "type"
  end

  create_table "applicants", id: :serial, force: :cascade do |t|
    t.string "type", limit: 30
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "country", limit: 3
    t.string "mobile", limit: 20
    t.integer "status", default: 0
    t.hstore "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cohort_id"
    t.index ["cohort_id"], name: "index_applicants_on_cohort_id"
  end

  create_table "auth_providers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_auth_providers_on_user_id"
  end

  create_table "badge_ownerships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "badge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "required_points"
    t.string "image_url"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "giving_method"
  end

  create_table "billing_charges", id: :serial, force: :cascade do |t|
    t.string "uid", limit: 50
    t.integer "user_id"
    t.integer "payment_method", default: 0
    t.integer "status", default: 0
    t.string "currency", limit: 5
    t.decimal "amount"
    t.decimal "tax"
    t.decimal "tax_percentage"
    t.string "description"
    t.hstore "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_billing_charges_on_user_id"
  end

  create_table "billing_coupons", id: :serial, force: :cascade do |t|
    t.string "name", limit: 30
    t.decimal "discount"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_completions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_completions_on_challenge_id"
    t.index ["user_id"], name: "index_challenge_completions_on_user_id"
  end

  create_table "challenges", id: :serial, force: :cascade do |t|
    t.integer "subject_id"
    t.string "name", limit: 100
    t.text "instructions"
    t.text "evaluation"
    t.integer "row"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "evaluation_strategy"
    t.string "solution_video_url"
    t.text "solution_text"
    t.boolean "restricted", default: false
    t.boolean "preview", default: false
    t.boolean "pair_programming", default: false
    t.integer "difficulty_bonus"
    t.integer "timeout"
    t.index ["subject_id"], name: "index_challenges_on_subject_id"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string "name"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.text "text"
    t.integer "response_to_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "course_phases", id: :serial, force: :cascade do |t|
    t.integer "subject_id"
    t.integer "phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.integer "folder_id"
    t.string "folder_type"
    t.string "name", limit: 50
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_type", "folder_id"], name: "index_documents_on_folder_type_and_folder_id"
  end

  create_table "email_templates", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "innovate_applicant_tests", force: :cascade do |t|
    t.bigint "applicant_id"
    t.integer "lang"
    t.string "a1"
    t.string "a2"
    t.string "a3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_innovate_applicant_tests_on_applicant_id"
  end

  create_table "lesson_completions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_completions_on_lesson_id"
    t.index ["user_id"], name: "index_lesson_completions_on_user_id"
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.integer "section_id"
    t.string "name"
    t.string "video_url"
    t.text "description"
    t.integer "row"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "free_preview", default: false
    t.text "info"
    t.string "video_duration"
    t.index ["section_id"], name: "index_lessons_on_section_id"
  end

  create_table "levels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "required_points"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notification_type"
    t.json "data"
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["status"], name: "index_notifications_on_status"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "path_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "path_id"
    t.integer "user_id"
    t.index ["path_id"], name: "index_path_subscriptions_on_path_id"
    t.index ["user_id"], name: "index_path_subscriptions_on_user_id"
  end

  create_table "paths", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
  end

  create_table "phases", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "row"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.integer "path_id"
    t.index ["path_id"], name: "index_phases_on_path_id"
  end

  create_table "points", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "subject_id"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pointable_id"
    t.string "pointable_type"
    t.index ["pointable_type", "pointable_id"], name: "index_points_on_pointable_type_and_pointable_id"
    t.index ["subject_id"], name: "index_points_on_subject_id"
  end

  create_table "project_solutions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "repository"
    t.string "url"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["project_id"], name: "index_project_solutions_on_project_id"
    t.index ["user_id"], name: "index_project_solutions_on_user_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.integer "subject_id"
    t.string "name"
    t.text "explanation_text"
    t.string "explanation_video_url"
    t.boolean "published"
    t.integer "row"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "difficulty_bonus", default: 0
    t.index ["subject_id"], name: "index_projects_on_subject_id"
  end

  create_table "question_attempts", id: :serial, force: :cascade do |t|
    t.integer "quiz_attempt_id"
    t.integer "question_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.decimal "score"
    t.index ["question_id"], name: "index_question_attempts_on_question_id"
    t.index ["quiz_attempt_id"], name: "index_question_attempts_on_quiz_attempt_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "quiz_id"
    t.string "type"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published"
    t.text "explanation"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_attempts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.decimal "score"
    t.integer "current_question", default: 0
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.integer "subject_id"
    t.string "title", limit: 100
    t.string "description"
    t.integer "row"
    t.string "url"
    t.string "time_estimate", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.string "slug"
    t.boolean "published"
    t.string "video_url"
    t.integer "category"
    t.boolean "own"
    t.string "type", limit: 100
    t.index ["subject_id"], name: "index_resources_on_subject_id"
  end

  create_table "resources_users", id: false, force: :cascade do |t|
    t.integer "resource_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resource_id", "user_id"], name: "index_resources_users_on_resource_id_and_user_id", unique: true
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.integer "resource_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row"
    t.index ["resource_id"], name: "index_sections_on_resource_id"
  end

  create_table "solutions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attempts"
    t.hstore "properties"
    t.index ["challenge_id"], name: "index_solutions_on_challenge_id"
    t.index ["properties"], name: "solutions_gin_properties", using: :gin
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50
    t.integer "row"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_estimate", limit: 50
    t.string "excerpt"
    t.string "description"
    t.string "slug"
    t.boolean "published"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.text "cancellation_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "top_applicant_tests", id: :serial, force: :cascade do |t|
    t.integer "applicant_id"
    t.string "a1"
    t.text "a2"
    t.text "a3"
    t.text "a4"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lang", default: 0
    t.index ["applicant_id"], name: "index_top_applicant_tests_on_applicant_id"
  end

  create_table "top_invitations", force: :cascade do |t|
    t.string "email"
    t.string "token", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_active_at"
    t.hstore "profile"
    t.integer "status"
    t.hstore "settings"
    t.integer "account_type"
    t.string "nickname"
    t.integer "level_id"
    t.string "password_digest"
    t.integer "access_type", default: 0
    t.integer "current_points", default: 0
    t.bigint "group_id"
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["level_id"], name: "index_users_on_level_id"
  end

  create_table "version_associations", id: :serial, force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  create_table "webinars_participants", force: :cascade do |t|
    t.bigint "webinar_id"
    t.string "email", limit: 150, null: false
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_webinars_participants_on_token", unique: true
    t.index ["webinar_id"], name: "index_webinars_participants_on_webinar_id"
  end

  create_table "webinars_speakers", force: :cascade do |t|
    t.bigint "webinar_id"
    t.string "name", null: false
    t.string "avatar_url"
    t.string "bio"
    t.boolean "external", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webinar_id"], name: "index_webinars_speakers_on_webinar_id"
  end

  create_table "webinars_webinars", force: :cascade do |t|
    t.string "title", limit: 150, null: false
    t.string "slug", limit: 100, null: false
    t.text "description"
    t.datetime "date", null: false
    t.string "image_url"
    t.string "event_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "users"
  add_foreign_key "applicants", "cohorts", on_delete: :cascade
  add_foreign_key "auth_providers", "users"
  add_foreign_key "billing_charges", "users"
  add_foreign_key "challenge_completions", "challenges"
  add_foreign_key "challenge_completions", "users"
  add_foreign_key "challenges", "subjects"
  add_foreign_key "comments", "users"
  add_foreign_key "innovate_applicant_tests", "applicants"
  add_foreign_key "lesson_completions", "lessons"
  add_foreign_key "lesson_completions", "users"
  add_foreign_key "lessons", "sections"
  add_foreign_key "notifications", "users"
  add_foreign_key "path_subscriptions", "paths"
  add_foreign_key "path_subscriptions", "users"
  add_foreign_key "phases", "paths"
  add_foreign_key "points", "subjects"
  add_foreign_key "project_solutions", "projects"
  add_foreign_key "project_solutions", "users"
  add_foreign_key "projects", "subjects"
  add_foreign_key "question_attempts", "questions"
  add_foreign_key "question_attempts", "quiz_attempts"
  add_foreign_key "questions", "resources", column: "quiz_id"
  add_foreign_key "quiz_attempts", "resources", column: "quiz_id"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "resources", "subjects"
  add_foreign_key "solutions", "challenges"
  add_foreign_key "solutions", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "top_applicant_tests", "applicants"
  add_foreign_key "users", "groups", on_delete: :cascade
  add_foreign_key "users", "levels"
  add_foreign_key "webinars_participants", "webinars_webinars", column: "webinar_id", on_delete: :cascade
  add_foreign_key "webinars_speakers", "webinars_webinars", column: "webinar_id", on_delete: :cascade
end
