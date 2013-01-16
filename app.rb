require 'sinatra/base'
require 'mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: Integer
  field :email, type: String
  field :token, type: String
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
    erb :home
  end

  run! if app_file == $0
end
