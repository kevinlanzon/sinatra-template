require 'sinatra/base'
require 'sinatra/flash'
require 'data_mapper'
require './app/models/user'
require 'tilt/erb'
require_relative 'data_mapper_setup'

class SinatraApp < Sinatra::Base

  set :views, proc { File.join(root, '..', '/app/views') }
  set :public_folder, Proc.new { File.join(root, '..', "public") }

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash
  use Rack::MethodOverride

  get '/' do
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if @user.save #save returns true/false depending on whether the model is successfully saved to the database.
    session[:user_id] = @user.id
    redirect to('/')
    # if it's not valid,
    # we'll render the sign up form again
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    erb :'sessions/goodbye'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
