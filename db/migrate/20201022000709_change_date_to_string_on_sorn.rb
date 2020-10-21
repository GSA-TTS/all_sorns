class ChangeDateToStringOnSorn < ActiveRecord::Migration[6.0]
  def up
    change_column :sorns, :publication_date, :string
  end

  def down
    change_column :sorns, :publication_date, "date USING publication_date::date"
  end
end
