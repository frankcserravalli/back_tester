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

ActiveRecord::Schema.define(:version => 20121123011756) do

  create_table "bars", :force => true do |t|
    t.integer  "security_id"
    t.string   "period"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "wap"
    t.integer  "volume"
    t.date     "date"
    t.time     "started_at"
    t.time     "ended_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bars", ["date"], :name => "index_bars_on_date"
  add_index "bars", ["security_id"], :name => "index_bars_on_security_id"

  create_table "securities", :force => true do |t|
    t.string   "symbol"
    t.string   "type"
    t.float    "strike"
    t.string   "currency"
    t.integer  "multiplier"
    t.date     "expiry"
    t.string   "exchange"
    t.string   "rights"
    t.boolean  "is_active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "securities", ["symbol"], :name => "index_securities_on_symbol", :unique => true

end
