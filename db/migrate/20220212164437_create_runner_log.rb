class CreateRunnerLog < ActiveRecord::Migration[7.0]
  def self.up
    create_table :runner_logs do |t|
      t.string :function_name, null: false, unique: true
      t.datetime :last_run_time, null: false
    end

    add_index :runner_logs, :function_name, unique: true
  end
end
