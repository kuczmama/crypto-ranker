class GithubData < ActiveRecord::Migration[7.0]
  def self.up
    create_table :github_data do |t|
      t.string :language, null: false, default: ""
      t.integer :watchers_count, null: false, default: 0
      t.integer :open_issues_count, null: false, default: 0
      t.integer :commit_count, null: false, default: 0
      t.integer :contributors_count, null: false , default: 0
      t.integer :stars_count, null: false, default: 0
      t.integer :forks_count, null: false, default: 0
      t.integer :size, null: false, default: 0
      t.integer :days_since_last_commit, null: false, default: 0
      t.string :source_code_url, null: false
      t.string :owner, null: false, default: ""
      t.string :repo, null: false, default: ""
      t.timestamps
    end
  end
end
