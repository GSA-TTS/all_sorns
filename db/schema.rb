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

ActiveRecord::Schema.define(version: 2021_03_03_182701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name"
    t.integer "api_id"
    t.integer "parent_api_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "short_name"
    t.index ["api_id"], name: "index_agencies_on_api_id"
    t.index ["parent_api_id"], name: "index_agencies_on_parent_api_id"
  end

  create_table "agencies_sorns", force: :cascade do |t|
    t.bigint "agency_id"
    t.bigint "sorn_id"
    t.index ["agency_id"], name: "index_agencies_sorns_on_agency_id"
    t.index ["sorn_id"], name: "index_agencies_sorns_on_sorn_id"
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

  create_table "mentions", id: false, force: :cascade do |t|
    t.integer "sorn_id"
    t.integer "mentioned_sorn_id"
    t.index ["mentioned_sorn_id", "sorn_id"], name: "index_mentions_on_mentioned_sorn_id_and_sorn_id", unique: true
    t.index ["sorn_id", "mentioned_sorn_id"], name: "index_mentions_on_sorn_id_and_mentioned_sorn_id", unique: true
  end

  create_table "sorns", force: :cascade do |t|
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
    t.string "system_number"
    t.string "citation"
    t.string "agency_names"
    t.string "xml"
    t.string "publication_date"
    t.string "title"
    t.string "action_type"
    t.tsvector "agency_names_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(agency_names, ''::character varying))::text)" }
    t.tsvector "action_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(action, ''::character varying))::text)" }
    t.tsvector "summary_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(summary, ''::character varying))::text)" }
    t.tsvector "dates_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(dates, ''::character varying))::text)" }
    t.tsvector "addresses_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(addresses, ''::character varying))::text)" }
    t.tsvector "further_info_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(further_info, ''::character varying))::text)" }
    t.tsvector "supplementary_info_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(supplementary_info, ''::character varying))::text)" }
    t.tsvector "system_name_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(system_name, ''::character varying))::text)" }
    t.tsvector "system_number_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(system_number, ''::character varying))::text)" }
    t.tsvector "security_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(security, ''::character varying))::text)" }
    t.tsvector "location_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(location, ''::character varying))::text)" }
    t.tsvector "manager_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(manager, ''::character varying))::text)" }
    t.tsvector "authority_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(authority, ''::character varying))::text)" }
    t.tsvector "purpose_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(purpose, ''::character varying))::text)" }
    t.tsvector "categories_of_individuals_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(categories_of_individuals, ''::character varying))::text)" }
    t.tsvector "categories_of_record_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(categories_of_record, ''::character varying))::text)" }
    t.tsvector "source_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(source, ''::character varying))::text)" }
    t.tsvector "routine_uses_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(routine_uses, ''::character varying))::text)" }
    t.tsvector "storage_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(storage, ''::character varying))::text)" }
    t.tsvector "retrieval_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(retrieval, ''::character varying))::text)" }
    t.tsvector "retention_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(retention, ''::character varying))::text)" }
    t.tsvector "safeguards_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(safeguards, ''::character varying))::text)" }
    t.tsvector "access_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(access, ''::character varying))::text)" }
    t.tsvector "contesting_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(contesting, ''::character varying))::text)" }
    t.tsvector "notification_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(notification, ''::character varying))::text)" }
    t.tsvector "exemptions_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(exemptions, ''::character varying))::text)" }
    t.tsvector "history_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(history, ''::character varying))::text)" }
    t.tsvector "xml_tsvector", default: -> { "to_tsvector('english'::regconfig, (COALESCE(xml, ''::character varying))::text)" }
    t.index ["access_tsvector"], name: "index_sorns_on_access_tsvector", using: :gin
    t.index ["action_tsvector"], name: "index_sorns_on_action_tsvector", using: :gin
    t.index ["addresses_tsvector"], name: "index_sorns_on_addresses_tsvector", using: :gin
    t.index ["agency_names_tsvector"], name: "index_sorns_on_agency_names_tsvector", using: :gin
    t.index ["authority_tsvector"], name: "index_sorns_on_authority_tsvector", using: :gin
    t.index ["categories_of_individuals_tsvector"], name: "index_sorns_on_categories_of_individuals_tsvector", using: :gin
    t.index ["categories_of_record_tsvector"], name: "index_sorns_on_categories_of_record_tsvector", using: :gin
    t.index ["citation"], name: "index_sorns_on_citation"
    t.index ["contesting_tsvector"], name: "index_sorns_on_contesting_tsvector", using: :gin
    t.index ["dates_tsvector"], name: "index_sorns_on_dates_tsvector", using: :gin
    t.index ["exemptions_tsvector"], name: "index_sorns_on_exemptions_tsvector", using: :gin
    t.index ["further_info_tsvector"], name: "index_sorns_on_further_info_tsvector", using: :gin
    t.index ["history_tsvector"], name: "index_sorns_on_history_tsvector", using: :gin
    t.index ["location_tsvector"], name: "index_sorns_on_location_tsvector", using: :gin
    t.index ["manager_tsvector"], name: "index_sorns_on_manager_tsvector", using: :gin
    t.index ["notification_tsvector"], name: "index_sorns_on_notification_tsvector", using: :gin
    t.index ["purpose_tsvector"], name: "index_sorns_on_purpose_tsvector", using: :gin
    t.index ["retention_tsvector"], name: "index_sorns_on_retention_tsvector", using: :gin
    t.index ["retrieval_tsvector"], name: "index_sorns_on_retrieval_tsvector", using: :gin
    t.index ["routine_uses_tsvector"], name: "index_sorns_on_routine_uses_tsvector", using: :gin
    t.index ["safeguards_tsvector"], name: "index_sorns_on_safeguards_tsvector", using: :gin
    t.index ["security_tsvector"], name: "index_sorns_on_security_tsvector", using: :gin
    t.index ["source_tsvector"], name: "index_sorns_on_source_tsvector", using: :gin
    t.index ["storage_tsvector"], name: "index_sorns_on_storage_tsvector", using: :gin
    t.index ["summary_tsvector"], name: "index_sorns_on_summary_tsvector", using: :gin
    t.index ["supplementary_info_tsvector"], name: "index_sorns_on_supplementary_info_tsvector", using: :gin
    t.index ["system_name_tsvector"], name: "index_sorns_on_system_name_tsvector", using: :gin
    t.index ["system_number_tsvector"], name: "index_sorns_on_system_number_tsvector", using: :gin
    t.index ["xml_tsvector"], name: "index_sorns_on_xml_tsvector", using: :gin
  end

end
