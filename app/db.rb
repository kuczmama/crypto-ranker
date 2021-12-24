require_relative 'models/coin'
require 'yaml'
require 'active_record'

class Db
    @@initialized = false
    class << self
        def coins
            init_connection
            Coin
        end

        private

        def init_connection
            return if @@initialized
            f_path = File.expand_path(File.join(File.dirname(__FILE__), '..','config', 'database.yml'))
            db_config       = YAML::load(File.read(f_path))
            db_config_admin = db_config.merge({
                'database' => 'postgres',
                'schema_search_path' => 'public'})
            ActiveRecord::Base.establish_connection(db_config_admin)
            @@initialized = true
        end
    end
end