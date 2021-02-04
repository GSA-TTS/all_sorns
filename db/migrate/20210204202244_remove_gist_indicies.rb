class RemoveGistIndicies < ActiveRecord::Migration[6.0]
  def up
    remove_index :sorns, name: :access_idx if index_name_exists?(:sorns, :access_idx)
    remove_index :sorns, name: :action_idx if index_name_exists?(:sorns, :action_idx)
    remove_index :sorns, name: :addresses_idx if index_name_exists?(:sorns, :addresses_idx)
    remove_index :sorns, name: :agency_names_idx if index_name_exists?(:sorns, :agency_names_idx)
    remove_index :sorns, name: :authority_idx if index_name_exists?(:sorns, :authority_idx)
    remove_index :sorns, name: :categories_of_individuals_idx if index_name_exists?(:sorns, :categories_of_individuals_idx)
    remove_index :sorns, name: :categories_of_record_idx if index_name_exists?(:sorns, :categories_of_record_idx)
    remove_index :sorns, name: :contesting_idx if index_name_exists?(:sorns, :contesting_idx)
    remove_index :sorns, name: :dates_idx if index_name_exists?(:sorns, :dates_idx)
    remove_index :sorns, name: :exemptions_idx if index_name_exists?(:sorns, :exemptions_idx)
    remove_index :sorns, name: :further_info_idx if index_name_exists?(:sorns, :further_info_idx)
    remove_index :sorns, name: :history_idx if index_name_exists?(:sorns, :history_idx)
    remove_index :sorns, name: :location_idx if index_name_exists?(:sorns, :location_idx)
    remove_index :sorns, name: :manager_idx if index_name_exists?(:sorns, :manager_idx)
    remove_index :sorns, name: :notification_idx if index_name_exists?(:sorns, :notification_idx)
    remove_index :sorns, name: :purpose_idx if index_name_exists?(:sorns, :purpose_idx)
    remove_index :sorns, name: :retention_idx if index_name_exists?(:sorns, :retention_idx)
    remove_index :sorns, name: :retrieval_idx if index_name_exists?(:sorns, :retrieval_idx)
    remove_index :sorns, name: :routine_uses_idx if index_name_exists?(:sorns, :routine_uses_idx)
    remove_index :sorns, name: :safeguards_idx if index_name_exists?(:sorns, :safeguards_idx)
    remove_index :sorns, name: :security_idx if index_name_exists?(:sorns, :security_idx)
    remove_index :sorns, name: :source_idx if index_name_exists?(:sorns, :source_idx)
    remove_index :sorns, name: :storage_idx if index_name_exists?(:sorns, :storage_idx)
    remove_index :sorns, name: :summary_idx if index_name_exists?(:sorns, :summary_idx)
    remove_index :sorns, name: :supplementary_info_idx if index_name_exists?(:sorns, :supplementary_info_idx)
    remove_index :sorns, name: :system_name_idx if index_name_exists?(:sorns, :system_name_idx)
    remove_index :sorns, name: :system_number_idx if index_name_exists?(:sorns, :system_number_idx)
  end

  def down
  end
end
