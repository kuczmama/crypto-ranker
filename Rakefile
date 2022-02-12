require "yaml"
require "active_record"
require 'uri'
require 'byebug'

def db_config
  # Parse the databse.yml file or the DATABASE_URL environment variable
  # and return a hash with the connection information.
  # But the DATABASE_URL environment variable overrides the default.
  if !ENV['DATABASE_URL'].nil?
    db_url = URI.parse(ENV['DATABASE_URL'])
    {
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
    config = YAML::load(File.open('config/database.yml'))
    config.merge({'schema_search_path' => 'public'})
  end
end

def get_database_name
  db_config[:database] || db_config['database']
end

# Establish a database connection
def establish_connection
  ActiveRecord::Base.establish_connection(db_config)
end

# The admin connection is used to create and drop the database
# It is when we connect to the 'postgres' database.  The reason
# this is needed, is because we need to connect to activerecord
# from a different database, because we can't drop/create the database we are connected to.
def establish_admin_connection
  ActiveRecord::Base.establish_connection(
      db_config.merge({
          'database' => 'postgres',
          'schema_search_path' => 'public'
      }))
end

# Returns the time the last database migration was run.
# This is stored in the schema_migration table.
def get_last_migration_ran_time
  return 0 unless ActiveRecord::Base.connection.table_exists? 'schema_migrations'

  last_migration_ran_time = 0
  last_migration_ran_str =  ActiveRecord::SchemaMigration.last.try(:version)
  if !last_migration_ran_str.nil? && !last_migration_ran_str.to_s.empty?
    last_migration_ran_str.to_i
  else
    0
  end
end

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
  task :create do
    establish_admin_connection

    database_name = get_database_name
    raise "Database name cannot be nil" if database_name.nil?
    puts "Creating database '#{database_name}'"

    ActiveRecord::Base.connection.create_database(database_name)

    # We need to establish a connection with the new database
    establish_connection

    # This creates the schema_migrations table, it keeps track of when the last
    # Migration was ran.  This is a hidden table that isn't in the schema.rb
    # and it is also not in the migrations directory.
    #
    # It has a single version column that is used to keep track of the last
    # migration when it was ran, and it is created by default when we create
    
    ActiveRecord::Base.connection.create_table :schema_migrations, id: false do |t|
      t.string :version, null: false
    end
    ActiveRecord::Base.connection.add_index :schema_migrations, :version, unique: true
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    puts "migrating database"
    establish_connection

    # Default to 0, because it's never been run before
    Dir.glob(File.join('db', 'migrate', '**', '*.rb')) do |file|
      load file
      file.to_s.match(/\_([a-zA-z\_]+).rb/) do |fname|

        # We parse the date the time the migration was ran,
        # if the migration time is after the time the last migration was ran,
        # then we run the migration, else we skip it
        migration_date_str = file.to_s.split("/")[-1].split("_")[0]
        migration_time = migration_date_str.to_i
        last_migration_ran_time = get_last_migration_ran_time

        puts "migration_time: #{migration_time}, last_migration_ran_time: #{last_migration_ran_time}"
        if migration_time > last_migration_ran_time
          classname = fname.to_s.split('.rb')[0]
          klass = classname.split('_').collect(&:capitalize).join

          puts "Running migration: #{klass}"

          Object.const_get(klass).migrate(:up)
          ActiveRecord::SchemaMigration.insert({version: migration_time})
        else
          puts "Skipping #{fname} because it's already been ran #{migration_date_str}"
        end
      end
    end

    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    puts "Dropping database"
    # We need to establish a connection to a different database ie the postgres database
    # because we can't drop the database we are connected to, we can only drop a separate db.
    establish_admin_connection

    database_name = get_database_name
    raise "Database name cannot be nil" if database_name.nil?

    # Drop the database
    ActiveRecord::Base.connection.drop_database(database_name)
    puts "Database deleted."
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
    establish_admin_connection
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

