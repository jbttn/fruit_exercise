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
  tast migrate: :environment do
    #
  end

  desc "Erase and populate the database with random data."
  task populate: :environment do
    #
  end
end