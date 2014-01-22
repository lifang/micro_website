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

ActiveRecord::Schema.define(:version => 20140122073232) do

  create_table "award_infos", :force => true do |t|
    t.integer  "award_id"
    t.string   "name"
    t.string   "content"
    t.integer  "number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "img"
    t.integer  "award_index"
  end

  add_index "award_infos", ["award_id"], :name => "index_award_infos_on_award_id"

  create_table "awards", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "total_number"
    t.integer  "no_operation_number"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "awards", ["site_id"], :name => "index_awards_on_site_id"

  create_table "client_html_infos", :force => true do |t|
    t.integer  "client_id"
    t.text     "hash_content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "mobiephone"
    t.integer  "site_id"
    t.text     "html_content"
    t.integer  "types"
    t.string   "password"
    t.string   "username"
    t.string   "avatar_url"
    t.boolean  "has_new_message"
    t.boolean  "has_new_record"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "form_datas", :force => true do |t|
    t.integer  "page_id"
    t.text     "data_hash"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "form_datas", ["page_id"], :name => "index_form_datas_on_page_id"

  create_table "keywords", :force => true do |t|
    t.integer  "site_id"
    t.string   "keyword"
    t.integer  "micro_message_id"
    t.boolean  "types"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "site_id"
    t.integer  "from_user"
    t.integer  "to_user"
    t.integer  "types"
    t.text     "content"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "micro_imgtexts", :force => true do |t|
    t.string   "title"
    t.string   "img_path"
    t.text     "content"
    t.string   "url"
    t.integer  "micro_message_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "micro_messages", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "mtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "page_image_texts", :force => true do |t|
    t.integer "page_id"
    t.text    "img_path"
    t.text    "content"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "file_name"
    t.integer  "types",            :limit => 1
    t.integer  "site_id"
    t.string   "path_name"
    t.boolean  "authenticate"
    t.text     "element_relation"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "img_path"
    t.text     "page_html"
    t.integer  "template",                      :default => 0
  end

  add_index "pages", ["authenticate"], :name => "index_pages_on_authenticate"
  add_index "pages", ["site_id"], :name => "index_pages_on_site_id"
  add_index "pages", ["types"], :name => "index_pages_on_types"

  create_table "posts", :force => true do |t|
    t.text     "post_content"
    t.integer  "post_status"
    t.integer  "site_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "title"
    t.string   "post_img"
    t.integer  "praise_number", :default => 0
  end

  create_table "recently_clients", :force => true do |t|
    t.integer  "site_id"
    t.integer  "client_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "records", :force => true do |t|
    t.integer  "site_id"
    t.text     "content"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reminds", :force => true do |t|
    t.integer  "site_id"
    t.string   "content"
    t.date     "reseve_time"
    t.string   "title"
    t.boolean  "range"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "replies", :force => true do |t|
    t.integer  "post_id"
    t.string   "reply_content"
    t.integer  "send_open_id"
    t.integer  "target_open_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "status",         :limit => 1, :default => 1
  end

  create_table "resources", :force => true do |t|
    t.string   "path_name"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "resources", ["path_name"], :name => "index_resources_on_path_name"
  add_index "resources", ["site_id"], :name => "index_resources_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "root_path"
    t.string   "notes"
    t.integer  "status",     :limit => 1
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "cweb"
    t.integer  "template",                :default => 1
  end

  add_index "sites", ["name"], :name => "index_sites_on_name"
  add_index "sites", ["root_path"], :name => "index_sites_on_root_path"
  add_index "sites", ["status"], :name => "index_sites_on_status"
  add_index "sites", ["user_id"], :name => "index_sites_on_user_id"

  create_table "user_awards", :force => true do |t|
    t.integer  "award_info_id"
    t.string   "open_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "award_id"
    t.string   "secret_code"
    t.boolean  "if_checked"
  end

  add_index "user_awards", ["award_info_id"], :name => "index_user_awards_on_award_info_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",                  :default => "", :null => false
    t.integer  "types",                  :limit => 1
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "status",                 :limit => 1
  end

  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["phone"], :name => "index_users_on_phone"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
