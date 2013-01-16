require 'sinatra/base'
require 'mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: Integer
  field :email, type: String
  field :token, type: String

  validates :uid, presence: true
  validates :email, presence: true
  validates :token, presence: true
end

class GitBook < Sinatra::Base

  configure do
    enable :sessions

    Mongoid.load!('mongoid.yml')
  end

  helpers do
    def logged_in?
      !!session['access_token']
    end
  end

  get '/' do
    erb :index
  end

  get '/home' do
    erb :home
  end

  post '/sessions/new' do
    uid = params[:uid]
    token = params[:token]
    email = params[:email]

    user = User.new(uid:uid, email:email, token:token)
    if(user.upsert)
      session['access_token'] = user.token
      p user.inspect
    else
      p user.errors.inspect
    end
  end

  get '/sessions/destroy' do
    session.clear
    redirect '/'
  end
  run! if app_file == $0
end
