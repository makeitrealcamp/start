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

ActiveRecord::Schema.define(version: 20150303212721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "name",         limit: 100
    t.text     "instructions"
    t.text     "evaluation"
    t.integer  "row"
    t.boolean  "published"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "challenges", ["course_id"], name: "index_challenges_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",          limit: 50
    t.integer  "row"
    t.text     "abstract"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "time_estimate", limit: 50
    t.string   "excerpt"
    t.string   "description"
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
  end

  add_index "resources", ["course_id"], name: "index_resources_on_course_id", using: :btree

  create_table "solutions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.integer  "status"
    t.integer  "attempts",     default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "solutions", ["challenge_id"], name: "index_solutions_on_challenge_id", using: :btree
  add_index "solutions", ["user_id"], name: "index_solutions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 100
    t.string   "roles",                                    array: true
    t.string   "password_digest"
    t.string   "first_name",      limit: 50
    t.string   "last_name",       limit: 50
    t.date     "birthday"
    t.string   "phone",           limit: 15
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
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

  add_foreign_key "challenges", "courses"
  add_foreign_key "resources", "courses"
  add_foreign_key "solutions", "challenges"
  add_foreign_key "solutions", "users"
end
