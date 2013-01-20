require 'sinatra/base'
require 'mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :repositories, dependent: :delete

  field :uid, type: Integer
  field :email, type: String
  field :token, type: String

  validates :uid, presence: true
  validates :email, presence: true
  validates :token, presence: true

  index({email: 1}, {unique: true, name: 'email_index'})
  index({token: 1}, {unique: true, name: 'token_index'})
end

class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :hooks, dependent: :delete

  field :short, type: String
  field :url, type: String
  field :webhook_url, type: String

  validates :short, presence: true
  validates :url, presence: true

  validates :short, format: { with: /\S*\/\S*/ }

  before_save do |document|
    webhook_url = "http://gitbook.com/hooks/#{document._id}/new"
    document.webhook_url = webhook_url
  end

  index({webhook_url: 1}, {unique: true, name: 'repo_webhook_index'})
end

class Hook
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :repository
end

class GitBook < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "This needs to be set for Shotgun to work"

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
    @user = User.where(token: session['access_token']).first
    @repos= @user.repositories
    erb :home
  end

  post '/repos/new' do
    #validate the repo url and then save
    #redirect to /home when done
  end

  post '/sessions/new' do
    uid = params[:uid]
    token = params[:token]
    email = params[:email]

    user = User.find_or_initialize_by(uid: uid).tap do |user|
      user.token = token
      user.email = email
    end
    if user.save!
      session['access_token'] = user.token
    else
      p.user.errors.inspect
    end
  end

  get '/sessions/destroy' do
    session.clear
    redirect '/'
  end
  run! if app_file == $0
end
