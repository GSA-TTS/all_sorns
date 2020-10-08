class AddIndexesToEverything < ActiveRecord::Migration[6.0]
  def change
    add_index :agencies, :name
    add_index :sorns, :system_name
    add_index :sorns, :system_number
    # add_index :sorns, :authority
    add_index :sorns, :action
    # add_index :sorns, :purpose
    # add_index :sorns, :categories_of_record
    add_index :sorns, :history
  end
end
