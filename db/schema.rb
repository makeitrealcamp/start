# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161018050108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"

  create_table "activity_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "activity_logs", ["activity_type", "activity_id"], name: "index_activity_logs_on_activity_type_and_activity_id", using: :btree
  add_index "activity_logs", ["user_id"], name: "index_activity_logs_on_user_id", using: :btree

  create_table "auth_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "auth_providers", ["user_id"], name: "index_auth_providers_on_user_id", using: :btree

  create_table "badge_ownerships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badges", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "required_points"
    t.string   "image_url"
    t.integer  "subject_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "giving_method"
  end

  create_table "challenge_completions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "challenge_completions", ["challenge_id"], name: "index_challenge_completions_on_challenge_id", using: :btree
  add_index "challenge_completions", ["user_id"], name: "index_challenge_completions_on_user_id", using: :btree

  create_table "challenges", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "name",                limit: 100
    t.text     "instructions"
    t.text     "evaluation"
    t.integer  "row"
    t.boolean  "published"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "slug"
    t.integer  "evaluation_strategy"
    t.string   "solution_video_url"
    t.text     "solution_text"
    t.boolean  "restricted",                      default: false
    t.boolean  "preview",                         default: false
    t.boolean  "pair_programming",                default: false
    t.integer  "difficulty_bonus"
    t.integer  "timeout"
  end

  add_index "challenges", ["subject_id"], name: "index_challenges_on_subject_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.integer  "response_to_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "course_phases", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "folder_id"
    t.string   "folder_type"
    t.string   "name",        limit: 50
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "documents", ["folder_type", "folder_id"], name: "index_documents_on_folder_type_and_folder_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "lesson_completions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lesson_completions", ["lesson_id"], name: "index_lesson_completions_on_lesson_id", using: :btree
  add_index "lesson_completions", ["user_id"], name: "index_lesson_completions_on_user_id", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.integer  "section_id"
    t.string   "name"
    t.string   "video_url"
    t.text     "description"
    t.integer  "row"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "free_preview",   default: false
    t.text     "info"
    t.string   "video_duration"
  end

  add_index "lessons", ["section_id"], name: "index_lessons_on_section_id", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "required_points"
    t.string   "image_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "notification_type"
    t.json     "data"
  end

  add_index "notifications", ["created_at"], name: "index_notifications_on_created_at", using: :btree
  add_index "notifications", ["status"], name: "index_notifications_on_status", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "path_subscriptions", force: :cascade do |t|
    t.integer "path_id"
    t.integer "user_id"
  end

  add_index "path_subscriptions", ["path_id"], name: "index_path_subscriptions_on_path_id", using: :btree
  add_index "path_subscriptions", ["user_id"], name: "index_path_subscriptions_on_user_id", using: :btree

  create_table "paths", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "published",   default: false
  end

  create_table "phases", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "row"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "color"
    t.integer  "path_id"
  end

  add_index "phases", ["path_id"], name: "index_phases_on_path_id", using: :btree

  create_table "points", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.integer  "points"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "pointable_id"
    t.string   "pointable_type"
  end

  add_index "points", ["pointable_type", "pointable_id"], name: "index_points_on_pointable_type_and_pointable_id", using: :btree
  add_index "points", ["subject_id"], name: "index_points_on_subject_id", using: :btree

  create_table "project_solutions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "repository"
    t.string   "url"
    t.text     "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  add_index "project_solutions", ["project_id"], name: "index_project_solutions_on_project_id", using: :btree
  add_index "project_solutions", ["user_id"], name: "index_project_solutions_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "name"
    t.text     "explanation_text"
    t.string   "explanation_video_url"
    t.boolean  "published"
    t.integer  "row"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "difficulty_bonus",      default: 0
  end

  add_index "projects", ["subject_id"], name: "index_projects_on_subject_id", using: :btree

  create_table "question_attempts", force: :cascade do |t|
    t.integer  "quiz_attempt_id"
    t.integer  "question_id"
    t.json     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "type"
    t.decimal  "score"
  end

  add_index "question_attempts", ["question_id"], name: "index_question_attempts_on_question_id", using: :btree
  add_index "question_attempts", ["quiz_attempt_id"], name: "index_question_attempts_on_quiz_attempt_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "quiz_id"
    t.string   "type"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "published"
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree

  create_table "quiz_attempts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.decimal  "score"
  end

  add_index "quiz_attempts", ["quiz_id"], name: "index_quiz_attempts_on_quiz_id", using: :btree
  add_index "quiz_attempts", ["user_id"], name: "index_quiz_attempts_on_user_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "title",         limit: 100
    t.string   "description"
    t.integer  "row"
    t.string   "url"
    t.string   "time_estimate", limit: 50
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "content"
    t.string   "slug"
    t.boolean  "published"
    t.string   "video_url"
    t.integer  "category"
    t.boolean  "own"
    t.string   "type",          limit: 100
  end

  add_index "resources", ["subject_id"], name: "index_resources_on_subject_id", using: :btree

  create_table "resources_users", id: false, force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources_users", ["resource_id", "user_id"], name: "index_resources_users_on_resource_id_and_user_id", unique: true, using: :btree

  create_table "sections", force: :cascade do |t|
    t.integer  "resource_id"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "row"
  end

  add_index "sections", ["resource_id"], name: "index_sections_on_resource_id", using: :btree

  create_table "solutions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "attempts"
    t.hstore   "properties"
  end

  add_index "solutions", ["challenge_id"], name: "index_solutions_on_challenge_id", using: :btree
  add_index "solutions", ["properties"], name: "solutions_gin_properties", using: :gin
  add_index "solutions", ["user_id"], name: "index_solutions_on_user_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",          limit: 50
    t.integer  "row"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "time_estimate", limit: 50
    t.string   "excerpt"
    t.string   "description"
    t.string   "slug"
    t.boolean  "published"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.text     "cancellation_reason"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 100
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "last_active_at"
    t.hstore   "profile"
    t.integer  "status"
    t.hstore   "settings"
    t.integer  "account_type"
    t.string   "nickname"
    t.integer  "level_id"
    t.string   "password_digest"
    t.integer  "access_type",                 default: 0
  end

  add_index "users", ["level_id"], name: "index_users_on_level_id", using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "activity_logs", "users"
  add_foreign_key "auth_providers", "users"
  add_foreign_key "challenge_completions", "challenges"
  add_foreign_key "challenge_completions", "users"
  add_foreign_key "challenges", "subjects"
  add_foreign_key "comments", "users"
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
  add_foreign_key "users", "levels"
end
