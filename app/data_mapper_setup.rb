require 'data_mapper'
require 'dm-validations'

env = ENV['RACK_ENV'] || 'development'

# we're telling datamapper to use a postgres database on localhost. The name will be "sinatra_app_test" or "sinatra_app_development" depending on the environment
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/sinatra_app_#{env}")

require './app/models/user' # require each model individually - the path may vary depending on your file structure.

# After declaring your models, you should finalise them
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell datamapper to create them
# DataMapper.auto_upgrade!
