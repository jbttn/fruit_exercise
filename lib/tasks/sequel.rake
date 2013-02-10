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

    # Storing an array of 1 million record hashes in memory seems silly (and slow), lets split into batches.
    amount = 1000000
    current_batch_size = batch_size = 1000

    puts "Inserting #{amount} records with a batch size of #{batch_size}..."

    number_of_batches = (amount.to_f / batch_size).ceil
    number_of_batches.times do |batch_number|
      records = []

      # A batch will normally be the size specified above, but in cases where the
      # division produces a remainder we will need a smaller batch size.
      if(number_of_batches * batch_size > amount && number_of_batches == batch_number + 1)
        current_batch_size = amount % batch_size
      end

      1.upto(current_batch_size) do |current_batch_count|
        # URLS is defined in the url.rb initializer
        record = {id: (batch_number * batch_size) + current_batch_count, url: URLS[:url].sample,
                  referrer: URLS[:referrer].sample, created_at: current_batch_count.days.ago.to_datetime}
        hash = Digest::MD5.hexdigest(record.to_s)
        record[:hash] = hash
        records << record
      end

      Dataset.multi_insert(records)

      if(batch_number % 100 == 0)
        puts "#{number_of_batches - batch_number} batches remaining."
      end
    end
  end
end