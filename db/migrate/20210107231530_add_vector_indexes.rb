class AddVectorIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :sorns, :agency_names_tsvector, using: :gin
    add_index :sorns, :action_tsvector, using: :gin
    add_index :sorns, :summary_tsvector, using: :gin
    add_index :sorns, :dates_tsvector, using: :gin
    add_index :sorns, :addresses_tsvector, using: :gin
    add_index :sorns, :further_info_tsvector, using: :gin
    add_index :sorns, :supplementary_info_tsvector, using: :gin
    add_index :sorns, :system_name_tsvector, using: :gin
    add_index :sorns, :system_number_tsvector, using: :gin
    add_index :sorns, :security_tsvector, using: :gin
    add_index :sorns, :location_tsvector, using: :gin
    add_index :sorns, :manager_tsvector, using: :gin
    add_index :sorns, :authority_tsvector, using: :gin
    add_index :sorns, :purpose_tsvector, using: :gin
    add_index :sorns, :categories_of_individuals_tsvector, using: :gin
    add_index :sorns, :categories_of_record_tsvector, using: :gin
    add_index :sorns, :source_tsvector, using: :gin
    add_index :sorns, :routine_uses_tsvector, using: :gin
    add_index :sorns, :storage_tsvector, using: :gin
    add_index :sorns, :retrieval_tsvector, using: :gin
    add_index :sorns, :retention_tsvector, using: :gin
    add_index :sorns, :safeguards_tsvector, using: :gin
    add_index :sorns, :access_tsvector, using: :gin
    add_index :sorns, :contesting_tsvector, using: :gin
    add_index :sorns, :notification_tsvector, using: :gin
    add_index :sorns, :exemptions_tsvector, using: :gin
    add_index :sorns, :history_tsvector, using: :gin
  end
end
