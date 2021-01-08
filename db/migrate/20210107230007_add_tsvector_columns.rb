class AddTsvectorColumns < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE sorns
      ADD COLUMN agency_names_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(agency_names, ''))) STORED,
      ADD COLUMN action_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(action, ''))) STORED,
      ADD COLUMN summary_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(summary, ''))) STORED,
      ADD COLUMN dates_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(dates, ''))) STORED,
      ADD COLUMN addresses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(addresses, ''))) STORED,
      ADD COLUMN further_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(further_info, ''))) STORED,
      ADD COLUMN supplementary_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(supplementary_info, ''))) STORED,
      ADD COLUMN system_name_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(system_name, ''))) STORED,
      ADD COLUMN system_number_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(system_number, ''))) STORED,
      ADD COLUMN security_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(security, ''))) STORED,
      ADD COLUMN location_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(location, ''))) STORED,
      ADD COLUMN manager_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(manager, ''))) STORED,
      ADD COLUMN authority_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(authority, ''))) STORED,
      ADD COLUMN purpose_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(purpose, ''))) STORED,
      ADD COLUMN categories_of_individuals_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(categories_of_individuals, ''))) STORED,
      ADD COLUMN categories_of_record_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(categories_of_record, ''))) STORED,
      ADD COLUMN source_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(source, ''))) STORED,
      ADD COLUMN routine_uses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(routine_uses, ''))) STORED,
      ADD COLUMN storage_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(storage, ''))) STORED,
      ADD COLUMN retrieval_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(retrieval, ''))) STORED,
      ADD COLUMN retention_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(retention, ''))) STORED,
      ADD COLUMN safeguards_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(safeguards, ''))) STORED,
      ADD COLUMN access_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(access, ''))) STORED,
      ADD COLUMN contesting_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(contesting, ''))) STORED,
      ADD COLUMN notification_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(notification, ''))) STORED,
      ADD COLUMN exemptions_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(exemptions, ''))) STORED,
      ADD COLUMN history_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(history, ''))) STORED;
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
