class Addrankscoretocoin < ActiveRecord::Migration[7.0]
  def self.up
      add_column :coins, :rank_score, :integer, default: 9999999
  end
end
