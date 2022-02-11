require "yaml"
require "active_record"
require 'uri'

namespace :cron do
  desc "Load all data into the database"
  task :load_all_data do
    require(File.expand_path('app/services/cron_script.rb', File.dirname(__FILE__)))
  end

  desc "Infer correct github url"
  task :infer_correct_github_url do
    require(File.expand_path('app/services/infer_correct_github_url.rb', File.dirname(__FILE__)))
  end

  desc "Calculate data ranks"
  task :calculate_ranks do
    require(File.expand_path('app/services/data_ranker.rb', File.dirname(__FILE__)))
    DataRanker.calculate_ranks
  end
end

namespace :db do
  # Parse the databse.yml file or the DATABASE_URL environment variable
  # and return a hash with the connection information.
  # But the DATABASE_URL environment variable overrides the default.
  db_config = nil
  if !ENV['DATABASE_URL'].nil?
    db_url = URI.parse(ENV['DATABASE_URL'])
    db_config = {
      adapter: "postgresql",
      host: db_url.host,
      port: db_url.port,
      username: db_url.user,
      password: db_url.password,
      database: db_url.path[1..-1],
      schema_search_path: 'public'
    }
  else
    # Default config
    db_config = YAML::load(File.open('config/database.yml'))
  end
  database_name = (db_config[:database] || db_config['database'])
  db_config_admin = db_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})

  puts "Using database configuration: #{db_config.inspect}"

  migration_file = File.join("db","migrate",".last_migration_ran.txt")

  desc "Create the database #{database_name}"
  task :create do
    puts "Creating database '#{database_name}'..."
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(database_name)
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    # Default to 0, because it's never been run before
    last_migration_ran_time = 0
    if File.exist?(migration_file)
      last_migration_ran_str = File.read(migration_file)
      puts "last_migration_ran_str: #{last_migration_ran_str}"
      begin
        last_migration_ran_time = last_migration_ran_str.to_i
      rescue
        last_migration_ran_time = 0
      end
    end

    ActiveRecord::Base.establish_connection(db_config)
    Dir.glob(File.join('db', 'migrate', '**', '*.rb')) do |file|
      load file
      file.to_s.match(/\_([a-zA-z\_]+).rb/) do |fname|

        # We parse the date the time the migration was ran,
        # if the migration time is after the time the last migration was ran,
        # then we run the migration, else we skip it
        migration_date_str = file.to_s.split("/")[-1].split("_")[0]
        migration_time = migration_date_str.to_i

        puts "migration_time: #{migration_time}, last_migration_ran_time: #{last_migration_ran_time}"
        if migration_time > last_migration_ran_time
          classname = fname.to_s.split('.rb')[0]
          klass = classname.split('_').collect(&:capitalize).join

          Object.const_get(klass).migrate(:up)
          File.open(migration_file, 'w') { |f| f.write(migration_date_str) }
        else
          puts "Skipping #{fname} because it's already been ran #{migration_date_str}"
        end
      end
    end

    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(database_name)
    puts "Database deleted."
    # Delete the migration file
    File.delete(migration_file) if File.exist?(migration_file)
    puts "migration file deleted"
  end

  desc "Seed the database"
  task :seed do
    puts "Seeding database..."
    File.open('db/seeds.rb') do |f|
      eval(f.read)
    end
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[7.0]
  def self.up
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end

