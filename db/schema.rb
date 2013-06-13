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

ActiveRecord::Schema.define(:version => 20130604191535) do

  create_table "act_needs", :force => true do |t|
    t.integer   "pos"
    t.string    "name"
    t.integer   "activity_id"
    t.integer   "qty_volunteers"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
  end

  create_table "activities", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.timestamp "starts_at"
    t.timestamp "ends_at"
    t.integer   "department_id"
    t.timestamp "rendezvous_at"
    t.string    "rendezvous_place"
    t.timestamp "created_at",       :null => false
    t.timestamp "updated_at",       :null => false
    t.string    "place"
    t.text      "address"
  end

  create_table "categories", :force => true do |t|
    t.string    "short_name"
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "certificates", :force => true do |t|
    t.integer   "volunteer_id"
    t.integer   "training_id"
    t.string    "number"
    t.date      "issued_on"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
  end

  create_table "colors", :force => true do |t|
    t.string    "name"
    t.string    "hex"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "containers", :force => true do |t|
    t.string    "short_name"
    t.integer   "container_id"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
    t.integer   "quantity"
    t.string    "name"
    t.string    "model"
    t.integer   "pos"
    t.integer   "status"
  end

  create_table "contents", :force => true do |t|
    t.integer   "item_id"
    t.integer   "container_id"
    t.integer   "quantity"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
    t.boolean   "unitary"
    t.integer   "pos"
  end

  create_table "departments", :force => true do |t|
    t.string    "name"
    t.string    "short_name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.integer   "color_id"
  end

  create_table "departments_volunteers", :id => false, :force => true do |t|
    t.integer "department_id", :null => false
    t.integer "volunteer_id",  :null => false
  end

  create_table "items", :force => true do |t|
    t.string    "nature"
    t.string    "produit"
    t.string    "condition"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
    t.integer   "category_id"
    t.boolean   "disposable"
    t.integer   "supplier_id"
  end

  create_table "purchases", :force => true do |t|
    t.integer  "item_id"
    t.string   "number"
    t.date     "purchased_on"
    t.text     "comment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "active"
    t.integer  "supplier_id"
  end

  create_table "registration_statuses", :force => true do |t|
    t.integer   "pos"
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.string    "short_name"
  end

  create_table "registrations", :force => true do |t|
    t.integer   "volunteer_id"
    t.integer   "activity_id"
    t.integer   "starts_delay"
    t.integer   "ends_delay"
    t.string    "rendezvous_place"
    t.timestamp "created_at",       :null => false
    t.timestamp "updated_at",       :null => false
    t.integer   "act_need_id"
    t.integer   "status_id"
  end

  create_table "sections", :force => true do |t|
    t.string    "name"
    t.string    "number"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "suppliers", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.text      "address"
  end

  create_table "trainings", :force => true do |t|
    t.string    "name"
    t.boolean   "active"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.integer   "pos"
    t.string    "short_name"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.integer   "activities_access"
    t.integer   "staff_access"
    t.integer   "equipment_access"
    t.string    "google_drive_password"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "volunteers", :force => true do |t|
    t.string    "cr_number"
    t.integer   "sex"
    t.string    "first_name"
    t.string    "last_name"
    t.date      "date_of_birth"
    t.string    "place_of_birth"
    t.string    "email"
    t.string    "land_phone"
    t.string    "cell_phone"
    t.date      "cr_joined_on"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
    t.integer   "pos"
    t.text      "address"
    t.string    "bank_account"
    t.integer   "section_id"
  end

end
