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

ActiveRecord::Schema.define(version: 2020_12_30_230531) do

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
    t.string "headers"
    t.string "system_number"
    t.string "data_source"
    t.string "citation"
    t.string "agency_names"
    t.xml "xml"
    t.string "pdf_url"
    t.string "text_url"
    t.string "publication_date"
    t.string "title"
    t.string "action_type"
    t.index ["citation"], name: "index_sorns_on_citation"
  end


  create_view "sorn_searches", materialized: true, sql_definition: <<-SQL
      SELECT sorns.id AS sorn_id,
      ((((((((((((((((((((((((((to_tsvector('english'::regconfig, (COALESCE(sorns.agency_names, ''::character varying))::text) || to_tsvector('english'::regconfig, (COALESCE(sorns.action, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.summary, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.dates, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.addresses, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.further_info, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.supplementary_info, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.system_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.system_number, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.security, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.location, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.manager, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.authority, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.purpose, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.categories_of_individuals, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.categories_of_record, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.source, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.routine_uses, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.storage, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.retrieval, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.retention, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.safeguards, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.access, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.contesting, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.notification, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.exemptions, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.history, ''::character varying))::text)) AS tsv_document
     FROM sorns;
  SQL
  add_index "sorn_searches", ["tsv_document"], name: "index_sorn_searches_on_tsv_document", using: :gin

end
