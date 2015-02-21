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

ActiveRecord::Schema.define(version: 20150221211419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "address",          limit: 255
    t.string   "email",            limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "org_nr",           limit: 255
    t.string   "ref",              limit: 255
    t.string   "delivery_address"
  end

  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "invoice_items", force: :cascade do |t|
    t.text     "description"
    t.decimal  "quantity",                precision: 8, scale: 2
    t.integer  "vat"
    t.integer  "user_id"
    t.integer  "invoice_id"
    t.decimal  "unit_price",              precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit",        limit: 255
  end

  add_index "invoice_items", ["invoice_id"], name: "index_invoice_items_on_invoice_id", using: :btree
  add_index "invoice_items", ["user_id"], name: "index_invoice_items_on_user_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "invoice_number"
    t.string   "order_date",        limit: 255
    t.string   "delivery_date",     limit: 255
    t.decimal  "total"
    t.string   "currency",          limit: 255
    t.text     "notes"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                          default: false
    t.string   "client_name",       limit: 255
    t.string   "client_address",    limit: 255
    t.string   "client_email",      limit: 255
    t.string   "client_org_nr",     limit: 255
    t.string   "client_ref",        limit: 255
    t.integer  "sends",                         default: 0
    t.string   "delivery_address"
    t.boolean  "kreditnota",                    default: false
    t.string   "user_name"
    t.string   "user_org_number"
    t.string   "user_email"
    t.string   "user_phone"
    t.string   "user_bank_swift"
    t.string   "user_bank_iban"
    t.string   "user_bank_name"
    t.string   "user_bank_account"
    t.string   "user_address"
    t.string   "user_ref"
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "description"
    t.string   "unit"
    t.decimal  "price"
    t.integer  "vat"
    t.integer  "user_id"
    t.string   "product_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",     null: false
    t.string   "encrypted_password",     limit: 255, default: "",     null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                               default: "user"
    t.string   "name",                   limit: 255
    t.string   "address",                limit: 255
    t.string   "phone",                  limit: 255
    t.string   "org_number",             limit: 255
    t.string   "bank_account",           limit: 255
    t.string   "bank_swift",             limit: 255
    t.string   "bank_iban",              limit: 255
    t.string   "bank_name",              limit: 255
    t.string   "ref"
    t.boolean  "mva_reg",                            default: false
    t.boolean  "foretaks_reg",                       default: false
    t.integer  "next_invoice_number",                default: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
