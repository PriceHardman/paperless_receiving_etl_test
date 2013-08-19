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

ActiveRecord::Schema.define(:version => 20130724231638) do

  create_table "freight_descriptions", :force => true do |t|
    t.string   "freight_description"
    t.string   "description_category"
    t.string   "rate_class_tli"
    t.string   "rate_units"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "pallets", :force => true do |t|
    t.integer  "fr_number"
    t.integer  "line_id"
    t.string   "description"
    t.date     "receive_date"
    t.integer  "pallet_number"
    t.integer  "item_quantity"
    t.integer  "item_length"
    t.integer  "item_width"
    t.integer  "item_height"
    t.string   "transferred"
    t.string   "hazard_id"
    t.string   "deck_stow"
    t.string   "rate_class_tli"
    t.string   "secondary_description"
    t.string   "service_class_id"
    t.string   "oversize_yn"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "weight_per_item"
  end

  create_table "tests", :force => true do |t|
    t.string   "sailing_date"
    t.string   "customer"
    t.string   "shipper"
    t.string   "consignee"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
