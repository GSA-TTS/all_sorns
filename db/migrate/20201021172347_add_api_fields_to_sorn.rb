class AddApiFieldsToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :api_action, :string
    add_column :sorns, :api_dates, :string
    add_column :sorns, :pdf_url, :string
    add_column :sorns, :text_url, :string
    add_column :sorns, :publication_date, :date
    add_column :sorns, :title, :string
  end
end
