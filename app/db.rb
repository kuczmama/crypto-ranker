require_relative 'models/coin'
require_relative 'models/github_metadata'
require_relative 'models/runner_log'
require 'yaml'
require 'active_record'

class Db
    @@initialized = false
    class << self
        def coins
            init_connection
            Coin
        end

        def github_metadata
            init_connection
            GithubMetadata
        end

        
        def runner_logs
            init_connection
            RunnerLog
        end

        private

        def init_connection
            return if @@initialized
            f_path = File.expand_path(File.join(File.dirname(__FILE__), '..','config', 'database.yml'))
            db_config       = YAML::load(File.read(f_path))
            db_config = db_config.merge({
                'schema_search_path' => 'public'})
            db_config = ENV['DATABASE_URL'] || db_config

            ActiveRecord::Base.establish_connection(db_config)
            @@initialized = true
        end
    end
end
