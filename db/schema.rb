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

ActiveRecord::Schema.define(:version => 20130306070117) do

  create_table "content_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "content_provider"
    t.string   "content_id"
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.string   "rating"
    t.string   "position"
    t.string   "time_added"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "context_options", :force => true do |t|
    t.integer  "context_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contexts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "idea_weights", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "context_id"
    t.integer  "context_option_id"
    t.integer  "weight"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "ideas", :force => true do |t|
    t.string   "name"
    t.integer  "context_bits"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "suggestion_tracks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_item_id"
    t.datetime "on"
    t.string   "via"
    t.string   "status"
    t.boolean  "opened"
    t.datetime "opened_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "netflix_user_id"
    t.string   "netflix_token"
    t.string   "netflix_secret"
    t.string   "instapaper_user_id"
    t.string   "instapaper_token"
    t.string   "instapaper_secret"
    t.string   "name"
    t.string   "netflix_status"
    t.string   "instapaper_status"
    t.string   "last_location"
    t.string   "last_latitude"
    t.string   "last_longitude"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
