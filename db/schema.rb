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

ActiveRecord::Schema.define(version: 20141219233518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "order_id"
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.string   "name"
    t.string   "number"
    t.string   "expiration"
    t.string   "cvv"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "total_cents"
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity",    default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["number"], name: "index_orders_on_number", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "canonical_name"
    t.text     "description"
    t.decimal  "weight",         precision: 15, scale: 2
    t.integer  "price_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "dimensions",                              array: true
  end

  add_index "products", ["canonical_name"], name: "index_products_on_canonical_name", using: :btree

end
