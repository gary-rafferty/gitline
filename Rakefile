require 'rake/testtask'

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

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/unit/*.rb']
  t.verbose = true
end

desc 'Send a sample payload to a repository (by _id)'
task :payload, :repo do |t,args|
  repo = args[:repo]
  sh "curl --data-urlencode payload@resources/sample_payload.json localhost:3000/hooks/#{repo}/new"
end

desc 'Send a sample payload to a repository on the Heroku server'
task :heroku_payload, :repo do |t,args|
  repo = args[:repo]
  sh "curl --data-urlencode payload@resources/sample_payload.json http://gitline.herokuapp.com/hooks/#{repo}/new"
end
