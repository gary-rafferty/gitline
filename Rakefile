desc 'Start the watcher for sass compilation'
task :watch do
  sh 'sass --watch public/stylesheets/sass/gitbook.css.scss:public/stylesheets/gitbook.css'
end

desc 'Start the web server (thin)'
task :server do
  sh 'thin -R config.ru start'
end

desc 'Drop the MongoDB database'
task :truncate do
  sh 'mongo gitbook_development --eval "db.dropDatabase()"'
end
