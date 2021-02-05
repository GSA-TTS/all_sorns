class RemoveUnusedColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :sorns, :data_source, :string
    remove_column :sorns, :pdf_url, :string
    remove_column :sorns, :headers, :string
    remove_column :sorns, :text_url, :string
  end
end
