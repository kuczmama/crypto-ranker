class EnableUuid < ActiveRecord::Migration[7.0]
    def self.up
      enable_extension 'pgcrypto'
    end
end