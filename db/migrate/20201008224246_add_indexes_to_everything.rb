class AddIndexesToEverything < ActiveRecord::Migration[6.0]
  def up
    Sorn::FIELDS.each {|field| execute "create index #{field}_idx on sorns using gist(to_tsvector('english', #{field}));" }
  end

  def down
    Sorn::FIELDS.each {|field| execute "drop index #{field}_idx;" }
  end
end
