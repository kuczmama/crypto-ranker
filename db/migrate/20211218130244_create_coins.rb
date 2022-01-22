class CreateCoins < ActiveRecord::Migration[7.0]
  def self.up
    create_table :coins do |t|
      t.integer :coin_marketcap_id, null: false, index: {unique: true}
      t.string :name, null: false, index: {unique: true}
      t.string :symbol, null: false, index: {unique: true}
      t.string :slug, null: false, index: {unique: true}
      t.integer :rank, null: false, default: 0
      t.string :source_code_url, null: false, default: ''
      t.timestamps
    end
  end
end
