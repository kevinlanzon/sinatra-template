class SinatraApp < Sinatra::Base

  get '/password_reset' do
    erb :'/password_reset'
  end

  post '/password_reset' do
    'Hello'
  end
end