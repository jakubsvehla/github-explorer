ENV['DATABASE_URL'] ||= 'postgres://localhost/github-explorer'

namespace :db do
  task :environment do
    require 'logger'
    require 'uri'
    require 'active_record'
    require 'pg'
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Seed the database"
  task(:seed => :environment) do
    require 'csv'
    require './models/category'
    require './models/route'

    CSV.table("routes.csv").each do |row|
      category = Category.find_or_create_by_name(row[:category])
      route = Route.new(method: row[:method], name: row[:route])
      route.category = category
      route.save

      puts "#{route.method} #{route.name}"
    end
  end
end
