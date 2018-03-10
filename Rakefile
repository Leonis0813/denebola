require 'active_record'
require 'mysql2'
require_relative 'config/initialize'

task :default => :migrate

namespace :db do
  desc 'Migrate database'
  task :migrate do
    ActiveRecord::Base.establish_connection(Settings.mysql.to_h)
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end
