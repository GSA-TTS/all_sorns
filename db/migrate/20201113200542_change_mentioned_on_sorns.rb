class ChangeMentionedOnSorns < ActiveRecord::Migration[6.0]
  def self.up
    create_table :mentions, id: false do |t|
      t.integer :sorn_id
      t.integer :mentioned_sorn_id
    end

    add_index(:mentions, [:sorn_id, :mentioned_sorn_id], :unique => true)
    add_index(:mentions, [:mentioned_sorn_id, :sorn_id], :unique => true)
  end

  def self.down
    remove_index(:mentions, [:mentioned_sorn_id, :sorn_id])
    remove_index(:mentions, [:sorn_id, :mentioned_sorn_id])
    drop_table :mentions
  end
end
