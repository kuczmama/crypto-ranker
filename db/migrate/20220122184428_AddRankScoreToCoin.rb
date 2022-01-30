class Addrankscoretocoin < ActiveRecord::Migration[7.0]
  def self.up
      add_column :coins, :rank_score, :float, default: -1
  end
end
