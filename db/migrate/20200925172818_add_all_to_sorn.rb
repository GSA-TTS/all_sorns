class AddAllToSorn < ActiveRecord::Migration[6.0]
  def change
    add_column :sorns, :summary, :string
    add_column :sorns, :dates, :string
    add_column :sorns, :addresses, :string
    add_column :sorns, :further_info, :string
    add_column :sorns, :supplementary_info, :string
    add_column :sorns, :security, :string
    add_column :sorns, :location, :string
    add_column :sorns, :manager, :string
    add_column :sorns, :categories_of_individuals, :string
    add_column :sorns, :source, :string
    add_column :sorns, :storage, :string
    add_column :sorns, :retrieval, :string
    add_column :sorns, :safeguards, :string
    add_column :sorns, :access, :string
    add_column :sorns, :contesting, :string
    add_column :sorns, :notification, :string
    remove_column :sorns, :sections
  end
end
