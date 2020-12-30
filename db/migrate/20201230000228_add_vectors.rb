class AddVectors < ActiveRecord::Migration[6.0]
  def up
    add_column :sorns, :agency_names_vector, :tsvector
    add_column :sorns, :action_vector, :tsvector
    add_column :sorns, :summary_vector, :tsvector
    add_column :sorns, :dates_vector, :tsvector
    add_column :sorns, :addresses_vector, :tsvector
    add_column :sorns, :further_info_vector, :tsvector
    add_column :sorns, :supplementary_info_vector, :tsvector
    add_column :sorns, :system_name_vector, :tsvector
    add_column :sorns, :system_number_vector, :tsvector
    add_column :sorns, :security_vector, :tsvector
    add_column :sorns, :location_vector, :tsvector
    add_column :sorns, :manager_vector, :tsvector
    add_column :sorns, :authority_vector, :tsvector
    add_column :sorns, :purpose_vector, :tsvector
    add_column :sorns, :categories_of_individuals_vector, :tsvector
    add_column :sorns, :categories_of_record_vector, :tsvector
    add_column :sorns, :source_vector, :tsvector
    add_column :sorns, :routine_uses_vector, :tsvector
    add_column :sorns, :storage_vector, :tsvector
    add_column :sorns, :retrieval_vector, :tsvector
    add_column :sorns, :retention_vector, :tsvector
    add_column :sorns, :safeguards_vector, :tsvector
    add_column :sorns, :access_vector, :tsvector
    add_column :sorns, :contesting_vector, :tsvector
    add_column :sorns, :notification_vector, :tsvector
    add_column :sorns, :exemptions_vector, :tsvector
    add_column :sorns, :history_vector, :tsvector

    execute <<-SQL
      CREATE TRIGGER agency_names_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(agency_names_vector, 'pg_catalog.english', agency_names);

      CREATE TRIGGER action_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(action_vector, 'pg_catalog.english', action);

      CREATE TRIGGER summary_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(summary_vector, 'pg_catalog.english', summary);

      CREATE TRIGGER dates_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(dates_vector, 'pg_catalog.english', dates);

      CREATE TRIGGER addresses_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(addresses_vector, 'pg_catalog.english', addresses);

      CREATE TRIGGER further_info_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(further_info_vector, 'pg_catalog.english', further_info);

      CREATE TRIGGER supplementary_info_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(supplementary_info_vector, 'pg_catalog.english', supplementary_info);

      CREATE TRIGGER system_name_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(system_name_vector, 'pg_catalog.english', system_name);

      CREATE TRIGGER system_number_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(system_number_vector, 'pg_catalog.english', system_number);

      CREATE TRIGGER security_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(security_vector, 'pg_catalog.english', security);

      CREATE TRIGGER location_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(location_vector, 'pg_catalog.english', location);

      CREATE TRIGGER manager_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(manager_vector, 'pg_catalog.english', manager);

      CREATE TRIGGER authority_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(authority_vector, 'pg_catalog.english', authority);

      CREATE TRIGGER purpose_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(purpose_vector, 'pg_catalog.english', purpose);

      CREATE TRIGGER categories_of_individuals_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(categories_of_individuals_vector, 'pg_catalog.english', categories_of_individuals);

      CREATE TRIGGER categories_of_record_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(categories_of_record_vector, 'pg_catalog.english', categories_of_record);

      CREATE TRIGGER source_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(source_vector, 'pg_catalog.english', source);

      CREATE TRIGGER routine_uses_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(routine_uses_vector, 'pg_catalog.english', routine_uses);

      CREATE TRIGGER storage_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(storage_vector, 'pg_catalog.english', storage);

      CREATE TRIGGER retrieval_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(retrieval_vector, 'pg_catalog.english', retrieval);

      CREATE TRIGGER retention_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(retention_vector, 'pg_catalog.english', retention);

      CREATE TRIGGER safeguards_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(safeguards_vector, 'pg_catalog.english', safeguards);

      CREATE TRIGGER access_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(access_vector, 'pg_catalog.english', access);

      CREATE TRIGGER contesting_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(contesting_vector, 'pg_catalog.english', contesting);

      CREATE TRIGGER notification_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(notification_vector, 'pg_catalog.english', notification);

      CREATE TRIGGER exemptions_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(exemptions_vector, 'pg_catalog.english', exemptions);

      CREATE TRIGGER history_trigger BEFORE INSERT OR UPDATE
      ON sorns FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(history_vector, 'pg_catalog.english', history);
    SQL
  end

  def down
    remove_column :sorns, :agency_names_vector
    remove_column :sorns, :action_vector
    remove_column :sorns, :summary_vector
    remove_column :sorns, :dates_vector
    remove_column :sorns, :addresses_vector
    remove_column :sorns, :further_info_vector
    remove_column :sorns, :supplementary_info_vector
    remove_column :sorns, :system_name_vector
    remove_column :sorns, :system_number_vector
    remove_column :sorns, :security_vector
    remove_column :sorns, :location_vector
    remove_column :sorns, :manager_vector
    remove_column :sorns, :authority_vector
    remove_column :sorns, :purpose_vector
    remove_column :sorns, :categories_of_individuals_vector
    remove_column :sorns, :categories_of_record_vector
    remove_column :sorns, :source_vector
    remove_column :sorns, :routine_uses_vector
    remove_column :sorns, :storage_vector
    remove_column :sorns, :retrieval_vector
    remove_column :sorns, :retention_vector
    remove_column :sorns, :safeguards_vector
    remove_column :sorns, :access_vector
    remove_column :sorns, :contesting_vector
    remove_column :sorns, :notification_vector
    remove_column :sorns, :exemptions_vector
    remove_column :sorns, :history_vector

    execute <<-SQL
      DROP TRIGGER agency_names_trigger ON sorns;
      DROP TRIGGER action_trigger ON sorns;
      DROP TRIGGER summary_trigger ON sorns;
      DROP TRIGGER dates_trigger ON sorns;
      DROP TRIGGER addresses_trigger ON sorns;
      DROP TRIGGER further_info_trigger ON sorns;
      DROP TRIGGER supplementary_info_trigger ON sorns;
      DROP TRIGGER system_name_trigger ON sorns;
      DROP TRIGGER system_number_trigger ON sorns;
      DROP TRIGGER security_trigger ON sorns;
      DROP TRIGGER location_trigger ON sorns;
      DROP TRIGGER manager_trigger ON sorns;
      DROP TRIGGER authority_trigger ON sorns;
      DROP TRIGGER purpose_trigger ON sorns;
      DROP TRIGGER categories_of_individuals_trigger ON sorns;
      DROP TRIGGER categories_of_record_trigger ON sorns;
      DROP TRIGGER source_trigger ON sorns;
      DROP TRIGGER routine_uses_trigger ON sorns;
      DROP TRIGGER storage_trigger ON sorns;
      DROP TRIGGER retrieval_trigger ON sorns;
      DROP TRIGGER retention_trigger ON sorns;
      DROP TRIGGER safeguards_trigger ON sorns;
      DROP TRIGGER access_trigger ON sorns;
      DROP TRIGGER contesting_trigger ON sorns;
      DROP TRIGGER notification_trigger ON sorns;
      DROP TRIGGER exemptions_trigger ON sorns;
      DROP TRIGGER history_trigger ON sorns;
    SQL
  end
end


