require 'active_record'
require 'mysql2'
require_relative 'config/initialize'

task :default => :migrate

namespace :db do
  desc 'Create database'
  task :reset do
    env = ENV['RAILS_ENV'] || 'development'
    settings = Settings.mysql.map {|key, value| [key.to_s, value] }.to_h
    ActiveRecord::Tasks::DatabaseTasks.database_configuration = settings
    ActiveRecord::Base.configurations = {env => settings}
    ActiveRecord::Tasks::DatabaseTasks.drop_current(env)
    ActiveRecord::Tasks::DatabaseTasks.create_current(env)
  end

  desc 'Migrate database'
  task :migrate do
    ActiveRecord::Base.establish_connection(Settings.mysql.to_h)
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end
end
