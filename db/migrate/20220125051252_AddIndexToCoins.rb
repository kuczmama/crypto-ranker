class Addindextocoins < ActiveRecord::Migration[7.0]
  def self.up
    add_index :coins, :rank
    add_index :coins, :rank_score
    add_index :coins, :created_at
    add_index :coins, :updated_at
    add_index :coins, :github_url
  end
end
