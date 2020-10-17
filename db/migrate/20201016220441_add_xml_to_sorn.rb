class AddXmlToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :xml, :xml
  end
end
