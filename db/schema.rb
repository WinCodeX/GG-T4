# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_04_190703) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agents", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "area_id", null: false
    t.bigint "location_id", null: false
    t.string "status", default: "active"
    t.string "phone"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_agents_on_area_id"
    t.index ["location_id"], name: "index_agents_on_location_id"
    t.index ["user_id"], name: "index_agents_on_user_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "location_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_areas_on_location_id"
    t.index ["name", "location_id"], name: "index_areas_on_name_and_location_id", unique: true
  end

  create_table "courier_services", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_courier_services_on_name", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "packages", force: :cascade do |t|
    t.string "recipient_name", null: false
    t.string "recipient_phone", null: false
    t.bigint "sender_agent_id", null: false
    t.bigint "receiver_agent_id"
    t.string "delivery_type", null: false
    t.bigint "receiver_area_id"
    t.bigint "receiver_location_id", null: false
    t.string "exact_location"
    t.bigint "courier_service_id"
    t.string "courier_service_manual"
    t.string "destination"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.string "payment_status", default: "pending_unpaid"
    t.string "package_status", default: "pending"
    t.string "tracking_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courier_service_id"], name: "index_packages_on_courier_service_id"
    t.index ["receiver_agent_id"], name: "index_packages_on_receiver_agent_id"
    t.index ["receiver_area_id"], name: "index_packages_on_receiver_area_id"
    t.index ["receiver_location_id"], name: "index_packages_on_receiver_location_id"
    t.index ["sender_agent_id"], name: "index_packages_on_sender_agent_id"
    t.index ["tracking_code"], name: "index_packages_on_tracking_code", unique: true
    t.check_constraint "package_status::text = ANY (ARRAY['pending'::character varying, 'in_transit'::character varying, 'delivered'::character varying, 'cancelled'::character varying]::text[])", name: "package_status_check"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agents", "areas"
  add_foreign_key "agents", "locations"
  add_foreign_key "agents", "users"
  add_foreign_key "areas", "locations"
  add_foreign_key "packages", "agents", column: "receiver_agent_id"
  add_foreign_key "packages", "agents", column: "sender_agent_id"
  add_foreign_key "packages", "areas", column: "receiver_area_id"
  add_foreign_key "packages", "courier_services"
  add_foreign_key "packages", "locations", column: "receiver_location_id"
end
