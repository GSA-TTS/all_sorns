# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_14_234853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "data_source"
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "sorns", force: :cascade do |t|
    t.bigint "agency_id", null: false
    t.string "system_name"
    t.string "authority"
    t.string "action"
    t.string "categories_of_record"
    t.string "html_url"
    t.string "xml_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "history"
    t.string "purpose"
    t.string "routine_uses"
    t.string "retention"
    t.string "exemptions"
    t.string "summary"
    t.string "dates"
    t.string "addresses"
    t.string "further_info"
    t.string "supplementary_info"
    t.string "security"
    t.string "location"
    t.string "manager"
    t.string "categories_of_individuals"
    t.string "source"
    t.string "storage"
    t.string "retrieval"
    t.string "safeguards"
    t.string "access"
    t.string "contesting"
    t.string "notification"
    t.string "headers"
    t.string "system_number"
    t.string "data_source"
    t.string "citation"
    t.index "to_tsvector('english'::regconfig, (access)::text)", name: "access_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (action)::text)", name: "action_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (addresses)::text)", name: "addresses_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (authority)::text)", name: "authority_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (categories_of_individuals)::text)", name: "categories_of_individuals_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (categories_of_record)::text)", name: "categories_of_record_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (contesting)::text)", name: "contesting_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (dates)::text)", name: "dates_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (exemptions)::text)", name: "exemptions_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (further_info)::text)", name: "further_info_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (history)::text)", name: "history_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (location)::text)", name: "location_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (manager)::text)", name: "manager_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (notification)::text)", name: "notification_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (purpose)::text)", name: "purpose_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (retention)::text)", name: "retention_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (retrieval)::text)", name: "retrieval_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (routine_uses)::text)", name: "routine_uses_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (safeguards)::text)", name: "safeguards_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (security)::text)", name: "security_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (source)::text)", name: "source_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (storage)::text)", name: "storage_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (summary)::text)", name: "summary_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (supplementary_info)::text)", name: "supplementary_info_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (system_name)::text)", name: "system_name_idx", using: :gist
    t.index "to_tsvector('english'::regconfig, (system_number)::text)", name: "system_number_idx", using: :gist
    t.index ["agency_id"], name: "index_sorns_on_agency_id"
    t.index ["citation"], name: "index_sorns_on_citation"
  end

  add_foreign_key "sorns", "agencies"
end
