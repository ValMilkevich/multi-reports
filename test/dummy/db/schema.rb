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

ActiveRecord::Schema.define(version: 20161129000004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reports_reports", force: :cascade do |t|
    t.string   "type",                       null: false
    t.json     "data",       default: {},    null: false
    t.string   "key",                        null: false
    t.datetime "timestamp",                  null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "temporary",  default: false
    t.datetime "from",                       null: false
    t.datetime "till",                       null: false
  end

  add_index "reports_reports", ["type", "key"], name: "index_reports_reports_on_type_and_key", unique: true, using: :btree
  add_index "reports_reports", ["type", "timestamp"], name: "index_reports_reports_on_type_and_timestamp", using: :btree

end