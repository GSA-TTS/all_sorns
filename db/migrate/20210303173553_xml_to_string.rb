  class XmlToString < ActiveRecord::Migration[6.0]
  def up
    change_column :sorns, :xml, :string

    execute <<-SQL
      ALTER TABLE sorns
      ADD COLUMN xml_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(sorns.xml, ''))) STORED
    SQL

    add_index :sorns, :xml_tsvector, using: :gin
  end

  def down
    remove_index :sorns, :xml_tsvector
    remove_column :sorns, :xml_tsvector

    execute <<-SQL
      ALTER TABLE sorns
      ALTER COLUMN xml TYPE xml USING xml::xml
    SQL
  end
end
