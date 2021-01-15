class AddTsvectorColumns < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE sorns
      ADD COLUMN agency_names_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.agency_names, ''))) STORED,
      ADD COLUMN action_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.action, ''))) STORED,
      ADD COLUMN summary_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.summary, ''))) STORED,
      ADD COLUMN dates_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.dates, ''))) STORED,
      ADD COLUMN addresses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.addresses, ''))) STORED,
      ADD COLUMN further_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.further_info, ''))) STORED,
      ADD COLUMN supplementary_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.supplementary_info, ''))) STORED,
      ADD COLUMN system_name_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.system_name, ''))) STORED,
      ADD COLUMN system_number_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.system_number, ''))) STORED,
      ADD COLUMN security_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.security, ''))) STORED,
      ADD COLUMN location_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.location, ''))) STORED,
      ADD COLUMN manager_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.manager, ''))) STORED,
      ADD COLUMN authority_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.authority, ''))) STORED,
      ADD COLUMN purpose_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.purpose, ''))) STORED,
      ADD COLUMN categories_of_individuals_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.categories_of_individuals, ''))) STORED,
      ADD COLUMN categories_of_record_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.categories_of_record, ''))) STORED,
      ADD COLUMN source_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.source, ''))) STORED,
      ADD COLUMN routine_uses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.routine_uses, ''))) STORED,
      ADD COLUMN storage_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.storage, ''))) STORED,
      ADD COLUMN retrieval_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.retrieval, ''))) STORED,
      ADD COLUMN retention_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.retention, ''))) STORED,
      ADD COLUMN safeguards_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.safeguards, ''))) STORED,
      ADD COLUMN access_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.access, ''))) STORED,
      ADD COLUMN contesting_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.contesting, ''))) STORED,
      ADD COLUMN notification_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.notification, ''))) STORED,
      ADD COLUMN exemptions_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.exemptions, ''))) STORED,
      ADD COLUMN history_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.history, ''))) STORED;
    SQL
  end

  def down
    remove_column :sorns, :agency_names_tsvector
    remove_column :sorns, :action_tsvector
    remove_column :sorns, :summary_tsvector
    remove_column :sorns, :dates_tsvector
    remove_column :sorns, :addresses_tsvector
    remove_column :sorns, :further_info_tsvector
    remove_column :sorns, :supplementary_info_tsvector
    remove_column :sorns, :system_name_tsvector
    remove_column :sorns, :system_number_tsvector
    remove_column :sorns, :security_tsvector
    remove_column :sorns, :location_tsvector
    remove_column :sorns, :manager_tsvector
    remove_column :sorns, :authority_tsvector
    remove_column :sorns, :purpose_tsvector
    remove_column :sorns, :categories_of_individuals_tsvector
    remove_column :sorns, :categories_of_record_tsvector
    remove_column :sorns, :source_tsvector
    remove_column :sorns, :routine_uses_tsvector
    remove_column :sorns, :storage_tsvector
    remove_column :sorns, :retrieval_tsvector
    remove_column :sorns, :retention_tsvector
    remove_column :sorns, :safeguards_tsvector
    remove_column :sorns, :access_tsvector
    remove_column :sorns, :contesting_tsvector
    remove_column :sorns, :notification_tsvector
    remove_column :sorns, :exemptions_tsvector
    remove_column :sorns, :history_tsvector
  end
end
