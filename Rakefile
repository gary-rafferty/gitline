desc 'Start the watcher for sass compilation'
task :watch do
  sh 'sass --watch public/stylesheets/sass/gitbook.css.scss:public/stylesheets/gitbook.css'
end

desc 'Start the web server (thin)'
task :server do
  sh 'shotgun --server=thin --port=3000 config.ru'
end

desc 'Drop the MongoDB database'
task :truncate do
  sh 'mongo gitbook_development --eval "db.dropDatabase()"'
end

desc 'Create the MongoDB indexes'
task :index do
  require './app'
  Mongoid.load!('mongoid.yml', :development)
  User.create_indexes
end
