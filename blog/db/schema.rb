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

ActiveRecord::Schema.define(version: 20161209132906) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "text",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "picture",    limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "slug",       limit: 255
  end

  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commenter",  limit: 255
    t.text     "body",       limit: 65535
    t.integer  "article_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "spam",       limit: 4
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "filename",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "article_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "username",   limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "role",       limit: 255
    t.string   "email",      limit: 255
    t.boolean  "subscriber", limit: 1,   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "comments", "articles"
end
