require 'sinatra/base'
require 'mongoid'
require 'httparty'

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
  has_many :payloads, dependent: :delete

  field :short, type: String
  field :webhook_url, type: String

  validates :short, presence: true
  validates :url, presence: true

  validates :short, format: { with: /\S*\/\S*/ }

  before_save do |document|
    webhook_url = "http://gitline.herokuapp.com/hooks/#{document._id}/new"
    document.webhook_url = webhook_url
  end

  index({webhook_url: 1}, {unique: true, name: 'repo_webhook_index'})
end

class Payload
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :repository

  field :before, type: String
  field :after, type: String
  field :ref, type: String
  field :commits, type: Array

  validates :before, presence: true
  validates :after, presence: true
  validates :ref, presence: true
  validates :commits, presence: true

  def pretty_commit
    after[0...7]
  end
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
    if logged_in?
      redirect '/home'
    end

    erb :index
  end

  get '/home' do
    @user = User.where(token: session['access_token']).first
    @repos= @user.repositories
    erb :home
  end

  post '/repos/new' do
    content_type :json

    @user = User.where(token: session['access_token']).first

    @short = params[:short]

    endpoint = "https://api.github.com/repos/#{@short}"
    @resp = JSON.parse(HTTParty.get(endpoint).body)

    if @resp.has_key? 'homepage'
      # got a good response
      # save and return a hook url
      repo = @user.repositories.build
      repo.short = @short
      repo.url = @resp['homepage']

      if repo.save
        redirect '/home'
      else
        [500, 'Could not save the repo'].to_json
      end
    else
      # no repo found :(
      [500, 'Incomplete API response'].to_json
    end
  end

  get '/repos/show/:id' do |id|
    @repository = Repository.where(_id: id).first
    @commits = @repository.payloads

    erb :show
  end

  post '/hooks/:id/new' do |id|
    repository = Repository.where(_id: id).first
    payload = JSON.parse(params[:payload])

    before = payload['before']
    after = payload['after']
    ref = payload['ref']
    commits = payload['commits']

    payload_obj = repository.payloads.build(
      before: before,
      after: after,
      ref: ref,
      commits: commits
    )

    if payload_obj.save
      [200,'OK'].to_json
    else
      [500,'Error'].to_json
    end
  end

  get '/commits/:id' do |id|
    @payload = Payload.where(_id: id).first

    if @payload
      erb :commit, :layout => :og_layout
    else
      [500, 'No Commit'].to_json
    end
  end

  post '/sessions/new' do
    uid = params[:uid]
    token = params[:token]
    email = params[:email]

    user = User.find_or_initialize_by(uid: uid).tap do |u|
      u.token = token
      u.email = email
    end
    if user.save!
      session['access_token'] = user.token
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
