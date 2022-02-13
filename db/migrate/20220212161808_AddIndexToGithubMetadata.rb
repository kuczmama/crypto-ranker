class Addindextogithubmetadata < ActiveRecord::Migration[7.0]
  def self.up
    if !ActiveRecord::Migration.connection.index_exists? :github_metadata, :source_code_url
        add_index :github_metadata, :source_code_url, unique: true
    end

    if !ActiveRecord::Migration.connection.index_exists? :github_metadata, :coin_id
      add_index :github_metadata, :coin_id, unique: true
    end
  end
end
