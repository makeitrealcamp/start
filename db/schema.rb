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

ActiveRecord::Schema.define(version: 20150421182420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "auth_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "auth_providers", ["user_id"], name: "index_auth_providers_on_user_id", using: :btree

  create_table "challenges", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "name",                limit: 100
    t.text     "instructions"
    t.text     "evaluation"
    t.integer  "row"
    t.boolean  "published"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "slug"
    t.integer  "evaluation_strategy"
    t.string   "solution_video_url"
    t.text     "solution_text"
  end

  add_index "challenges", ["course_id"], name: "index_challenges_on_course_id", using: :btree

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

  create_table "courses", force: :cascade do |t|
    t.string   "name",          limit: 50
    t.integer  "row"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "time_estimate", limit: 50
    t.string   "excerpt"
    t.string   "description"
    t.string   "slug"
    t.boolean  "published"
    t.integer  "visibility"
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

  create_table "resources", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "title",         limit: 100
    t.string   "description"
    t.integer  "row"
    t.integer  "type"
    t.string   "url"
    t.string   "time_estimate", limit: 50
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "content"
    t.string   "slug"
    t.boolean  "published"
  end

  add_index "resources", ["course_id"], name: "index_resources_on_course_id", using: :btree

  create_table "resources_users", id: false, force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "resource_id", null: false
  end

  add_index "resources_users", ["resource_id", "user_id"], name: "index_resources_users_on_resource_id_and_user_id", using: :btree
  add_index "resources_users", ["user_id", "resource_id"], name: "index_resources_users_on_user_id_and_resource_id", using: :btree

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

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 100
    t.string   "roles",                                    array: true
    t.string   "password_digest"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "last_active_at"
    t.hstore   "profile"
    t.integer  "status"
    t.hstore   "settings"
    t.integer  "account_type"
  end

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

  add_foreign_key "auth_providers", "users"
  add_foreign_key "challenges", "courses"
  add_foreign_key "comments", "users"
  add_foreign_key "resources", "courses"
  add_foreign_key "solutions", "challenges"
  add_foreign_key "solutions", "users"
end
