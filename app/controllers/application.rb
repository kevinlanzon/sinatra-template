class SinatraApp < Sinatra::Base

  get '/' do
    erb :index
  end
end
