
require 'bundler/setup'


Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
require_all 'lib'

#creating prompts for the controller 
PROMPT = TTY::Prompt.new