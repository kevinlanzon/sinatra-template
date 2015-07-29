require 'sinatra/base'
require 'sinatra/flash'
require 'data_mapper'
require 'tilt/erb'
require 'sinatra/partial'
require './app/models/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'
require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/application'
require_relative 'controllers/password_reset'

class SinatraApp < Sinatra::Base

  include UserSessions

  set :root, File.dirname(__FILE__) # sets app/. as default route
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash
  use Rack::MethodOverride
  register Sinatra::Partial
  set :partial_template_engine, :erb

  # start the server if ruby file executed directly
  run! if app_file == $0
end
