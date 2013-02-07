DB_INFO = YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))
DB_INFO = DB_INFO[::Rails.env]

def run_mysql_command(sql)
  command = "mysql -u#{DB_INFO['username']} -p#{DB_INFO['password']} -h#{DB_INFO['host']} -e '#{sql}'"
  system(command)
end

namespace :db do
  desc "Create database if it does not exist."
  task create: :environment do
    run_mysql_command("CREATE DATABASE IF NOT EXISTS #{DB_INFO["database"]}")
  end

  desc "Drop the database if it exists."
  task drop: :environment do
    run_mysql_command("DROP DATABASE IF EXISTS #{DB_INFO["database"]}")
  end

  desc "Run migrations."
  task migrate: :environment do
    Sequel.extension :migration
    Sequel::Migrator.apply(DB, File.join(::Rails.root, 'db', 'migrate'))
  end

  desc "Reset the database."
  task reset: :environment do
    DB.tables.each do |table|
      DB.run("DROP TABLE #{table}")
    end
    Rake::Task['db:migrate'].invoke(::Rails.env)
  end

  desc "Erase and populate the database with random data."
  task populate: :environment do
    Rake::Task['db:reset'].invoke(::Rails.env)

    
  end
end