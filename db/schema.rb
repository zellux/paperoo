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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120219102226) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "presentation_position"
    t.integer  "assistant_id"
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.integer  "conference_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_start"
    t.integer  "page_end"
    t.integer  "pageview",       :default => 0
    t.integer  "comments_count", :default => 0
  end

  create_table "author_lines", :force => true do |t|
    t.integer  "author_id"
    t.integer  "article_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "institute"
    t.integer  "articles_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pageview",       :default => 0
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "account_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"

  create_table "conferences", :force => true do |t|
    t.string   "title"
    t.integer  "year"
    t.string   "booktitle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "articles_count", :default => 0
    t.integer  "pageview",       :default => 0
  end

  create_table "likes", :force => true do |t|
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["likeable_id"], :name => "index_likes_on_likeable_id"

  create_table "presentations", :force => true do |t|
    t.integer  "article_id"
    t.integer  "account_id"
    t.integer  "assigner_id"
    t.datetime "assigned_date"
    t.datetime "presented_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presentations", ["article_id"], :name => "index_presentations_on_article_id", :unique => true

end
