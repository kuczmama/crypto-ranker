class CreateCoins < ActiveRecord::Migration[7.0]
  def self.up
    create_table :coins, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :coin_marketcap_id, null: false, index: {unique: true}
      t.string :name, null: false, index: {unique: true}
      t.string :symbol, null: false, index: {unique: true}
      t.string :slug, null: false, index: {unique: true}
      t.integer :rank, null: false, default: 9999999
      t.string :coin_marketcap_source_code_url, null: false, default: ''
      # The parsed github url in the format of https://github.com/owner/repo
      t.string :github_url, null: false, default: ""
      t.timestamps
    end
  end
end
