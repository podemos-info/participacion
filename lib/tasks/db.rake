namespace :db do
  desc "Resets the database and loads it from db/dev_seeds.rb"
  task dev_seed: :environment do
    load(Rails.root.join("db", "dev_seeds.rb"))
  end

  desc "add territories to database"
  task dev_territories: :environment do
    load(Rails.root.join("db", "territories.rb"))
  end
end
