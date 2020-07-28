require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.connection
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'migrate changes'
task :environment do
  require_relative './config/environment'
  User.create_table
  Lyric.create_table 
  UserLyric.create_table
  end
  


desc 'seed the database with some dummy data'
task :seed do
  require_relative './db/seeds.rb'
end
