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

ActiveRecord::Schema.define(version: 20170318223605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

# Could not dump table "biz_hours" because of following StandardError
#   Unknown type 'time with time zone' for column 'open_at'

  create_table "businesses", force: :cascade do |t|
    t.string   "biz_name"
    t.string   "biz_id"
    t.string   "external_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country_code"
    t.integer  "sid_category_id"
    t.string   "slug"
    t.string   "telephone"
    t.string   "website"
    t.string   "email"
    t.text     "sid_editorial"
    t.integer  "region_id"
  end

  add_index "businesses", ["biz_id"], name: "index_businesses_on_biz_id", unique: true, using: :btree
  add_index "businesses", ["region_id"], name: "index_businesses_on_region_id", using: :btree
  add_index "businesses", ["sid_category_id"], name: "index_businesses_on_sid_category_id", using: :btree
  add_index "businesses", ["slug"], name: "index_businesses_on_slug", unique: true, using: :btree

  create_table "deals", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "desc_short"
    t.string   "desc_student"
    t.text     "details"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "biz_id"
  end

  add_index "deals", ["biz_id"], name: "index_deals_on_biz_id", using: :btree
  add_index "deals", ["deal_id"], name: "index_deals_on_deal_id", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country_code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug"
    t.integer  "close_biz_count"
    t.string   "type"
    t.string   "display_name"
    t.integer  "school_id"
  end

  add_index "regions", ["school_id"], name: "index_regions_on_school_id", unique: true, using: :btree
  add_index "regions", ["slug"], name: "index_regions_on_slug", unique: true, using: :btree

  create_table "sid_categories", force: :cascade do |t|
    t.string   "sid_category_id"
    t.string   "label"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
    t.integer  "order"
  end

  add_index "sid_categories", ["sid_category_id"], name: "index_sid_categories_on_sid_category_id", unique: true, using: :btree
  add_index "sid_categories", ["slug"], name: "index_sid_categories_on_slug", unique: true, using: :btree

  create_table "signups", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.integer  "sid_category_id"
    t.string   "label"
    t.string   "ancestry"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
    t.string   "metadata_name"
    t.string   "metadata_value"
  end

  add_index "sub_categories", ["ancestry"], name: "index_sub_categories_on_ancestry", using: :btree
  add_index "sub_categories", ["sid_category_id"], name: "index_sub_categories_on_sid_category_id", using: :btree
  add_index "sub_categories", ["slug"], name: "index_sub_categories_on_slug", unique: true, using: :btree

  create_table "sub_category_taggings", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "sub_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "sub_category_taggings", ["business_id"], name: "index_sub_category_taggings_on_business_id", using: :btree
  add_index "sub_category_taggings", ["sub_category_id"], name: "index_sub_category_taggings_on_sub_category_id", using: :btree

  add_foreign_key "biz_hours", "businesses"
  add_foreign_key "businesses", "regions"
  add_foreign_key "businesses", "sid_categories"
  add_foreign_key "sub_categories", "sid_categories"
  add_foreign_key "sub_category_taggings", "businesses"
  add_foreign_key "sub_category_taggings", "sub_categories"
end
