class AddVectorIndexes < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE INDEX agency_names_vector_idx ON sorns USING GIN (agency_names_vector);
      CREATE INDEX action_vector_idx on sorns USING GIN (action_vector);
      CREATE INDEX summary_vector_idx on sorns USING GIN (summary_vector);
      CREATE INDEX dates_vector_idx on sorns USING GIN (dates_vector);
      CREATE INDEX addresses_vector_idx on sorns USING GIN (addresses_vector);
      CREATE INDEX further_info_vector_idx on sorns USING GIN (further_info_vector);
      CREATE INDEX supplementary_info_vector_idx on sorns USING GIN (supplementary_info_vector);
      CREATE INDEX system_name_vector_idx on sorns USING GIN (system_name_vector);
      CREATE INDEX system_number_vector_idx on sorns USING GIN (system_number_vector);
      CREATE INDEX security_vector_idx on sorns USING GIN (security_vector);
      CREATE INDEX location_vector_idx on sorns USING GIN (location_vector);
      CREATE INDEX manager_vector_idx on sorns USING GIN (manager_vector);
      CREATE INDEX authority_vector_idx on sorns USING GIN (authority_vector);
      CREATE INDEX purpose_vector_idx on sorns USING GIN (purpose_vector);
      CREATE INDEX categories_of_individuals_vector_idx on sorns USING GIN (categories_of_individuals_vector);
      CREATE INDEX categories_of_record_vector_idx on sorns USING GIN (categories_of_record_vector);
      CREATE INDEX source_vector_idx on sorns USING GIN (source_vector);
      CREATE INDEX routine_uses_vector_idx on sorns USING GIN (routine_uses_vector);
      CREATE INDEX storage_vector_idx on sorns USING GIN (storage_vector);
      CREATE INDEX retrieval_vector_idx on sorns USING GIN (retrieval_vector);
      CREATE INDEX retention_vector_idx on sorns USING GIN (retention_vector);
      CREATE INDEX safeguards_vector_idx on sorns USING GIN (safeguards_vector);
      CREATE INDEX access_vector_idx on sorns USING GIN (access_vector);
      CREATE INDEX contesting_vector_idx on sorns USING GIN (contesting_vector);
      CREATE INDEX notification_vector_idx on sorns USING GIN (notification_vector);
      CREATE INDEX exemptions_vector_idx on sorns USING GIN (exemptions_vector);
      CREATE INDEX history_vector_idx on sorns USING GIN (history_vector);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS agency_names_vector_idx;
      DROP INDEX IF EXISTS action_vector_idx;
      DROP INDEX IF EXISTS summary_vector_idx;
      DROP INDEX IF EXISTS dates_vector_idx;
      DROP INDEX IF EXISTS addresses_vector_idx;
      DROP INDEX IF EXISTS further_info_vector_idx;
      DROP INDEX IF EXISTS supplementary_info_vector_idx;
      DROP INDEX IF EXISTS system_name_vector_idx;
      DROP INDEX IF EXISTS system_number_vector_idx;
      DROP INDEX IF EXISTS security_vector_idx;
      DROP INDEX IF EXISTS location_vector_idx;
      DROP INDEX IF EXISTS manager_vector_idx;
      DROP INDEX IF EXISTS authority_vector_idx;
      DROP INDEX IF EXISTS purpose_vector_idx;
      DROP INDEX IF EXISTS categories_of_individuals_vector_idx;
      DROP INDEX IF EXISTS categories_of_record_vector_idx;
      DROP INDEX IF EXISTS source_vector_idx;
      DROP INDEX IF EXISTS routine_uses_vector_idx;
      DROP INDEX IF EXISTS storage_vector_idx;
      DROP INDEX IF EXISTS retrieval_vector_idx;
      DROP INDEX IF EXISTS retention_vector_idx;
      DROP INDEX IF EXISTS safeguards_vector_idx;
      DROP INDEX IF EXISTS access_vector_idx;
      DROP INDEX IF EXISTS contesting_vector_idx;
      DROP INDEX IF EXISTS notification_vector_idx;
      DROP INDEX IF EXISTS exemptions_vector_idx;
      DROP INDEX IF EXISTS history_vector_idx;
    SQL
  end
end
