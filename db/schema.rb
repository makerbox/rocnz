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

ActiveRecord::Schema.define(version: 20160920003754) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "suburb"
    t.string   "state"
    t.string   "country"
    t.string   "phone"
    t.string   "seller_level"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "approved"
    t.string   "code"
    t.string   "contact"
    t.string   "street"
    t.string   "postcode"
    t.string   "sort"
    t.string   "company"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "code"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "active"
    t.datetime "sent"
    t.boolean  "approved"
    t.boolean  "complete"
    t.decimal  "total"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "product_orders", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "qty"
  end

  add_index "product_orders", ["order_id"], name: "index_product_orders_on_order_id"
  add_index "product_orders", ["product_id"], name: "index_product_orders_on_product_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.decimal  "price1"
    t.decimal  "price2"
    t.decimal  "price3"
    t.decimal  "price4"
    t.decimal  "price5"
    t.decimal  "rrp"
    t.string   "code"
    t.string   "description"
    t.string   "group"
    t.string   "imageurl"
    t.integer  "qty"
    t.string   "category"
  end

  create_table "quantities", force: :cascade do |t|
    t.integer  "qty"
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "quantities", ["order_id"], name: "index_quantities_on_order_id"
  add_index "quantities", ["product_id"], name: "index_quantities_on_product_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
