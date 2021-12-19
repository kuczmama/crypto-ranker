class CreateCoins < ActiveRecord::Migration[7.0]
  def self.up
    create_table :coins do |t|
      t.integer :coin_marketcap_id, null: false
      t.string :name, null: false
      t.string :symbol, null: false
      t.string :slug, null: false
      t.integer :rank, null: false
    end
  end
end
