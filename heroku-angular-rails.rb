# see this. https://coderwall.com/p/4hqgrq
def source_paths
    [File.expand_path(File.dirname(__FILE__))]
end

@app_name = app_name
@app_name_val = "#{app_name.downcase}App"
@app_name_underscore = app_name.underscore

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'pry'
  gem 'pry-rails'
  gem 'rubocop'
end

gem_group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'faraday'
gem 'puma'
gem 'haml-rails'
gem 'mysql2'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem 'quiet_assets'
gem 'grape'
gem 'grape-jbuilder'
gem 'kaminari'
gem 'ngmin-rails'
gem 'rails_config', '0.3.4'
gem 'tapp'
gem 'whenever'
gem 'factory_girl_rails'
gem 'activerecord-import'
gem 'minimum-omniauth-scaffold'
gem 'rack-slashenforce'
gem 'bower-rails'

insert_into_file "config/application.rb",
                 "    Tapp.config.default_printer = :awesome_print\n" +
                 "    config.assets.paths << Rails.root.join(\"vendor\", \"assets\", \"javascripts\", \"bower_components\")\n" +
                 "    config.autoload_paths += %W(\#\{config.root\}/app/api)\n" +
                 "    config.middleware.use(Rack::Config) do |env|\n" +
                 "      env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api'\n" +
                 "    end\n",
                 after: "  class Application < Rails::Application\n"
remove_file '.gitignore'
copy_file '.gitignore'

copy_file '.rubocop.yml'

run 'rm -rf test/'

inside 'config' do
  remove_file 'database.yml'
  copy_file 'database.yml'
end
gsub_file 'config/database.yml', /__APPNAME__/, @app_name_underscore

copy_file 'Bowerfile'

route "match '*path', via: :get, to: 'template#index'"
route "match '/template/:ng_controller/:ng_action', via: :get, to: 'template#show'"
route "root to: 'template#index'"

# AngularJS Mock
inside 'app/assets/javascripts' do
  empty_directory 'ng_app'
  empty_directory 'ng_app/controllers'
  empty_directory 'ng_app/directives'
  empty_directory 'ng_app/filters'
  empty_directory 'ng_app/services'

  create_file 'ng_app/controllers/.gitkeep'
  create_file 'ng_app/directives/.gitkeep'
  create_file 'ng_app/filters/.gitkeep'
  create_file 'ng_app/services/.gitkeep'

  remove_file 'application.js'
  copy_file   'application.js'
  copy_file   'ng_app/controllers/PagesCtrl.js.coffee'
end

inside 'app/assets/javascripts/ng_app' do
  copy_file 'app.js.coffee'
end
gsub_file 'app/assets/javascripts/ng_app/app.js.coffee', /__APPNAME__/, "#{@app_name}App"
gsub_file 'app/assets/javascripts/ng_app/controllers/PagesCtrl.js.coffee', /__APPNAME__/, "#{@app_name}App"

inside 'app/views/layouts' do
  copy_file 'application.html.haml'
end
gsub_file 'app/views/layouts/application.html.haml', /__APPNAME__/, "#{@app_name}"

inside 'app/views/templates/pages' do
  copy_file 'index.html.haml'
  copy_file 'about.html.haml'
  copy_file '404.html.haml'
end

inside 'app/controllers' do
  copy_file 'template_controller.rb'
end
inside 'app/views/templates' do
  run 'touch index.html.haml'
end

## grape
route "mount API => '/api'"
environment 'config.autoload_paths += %W(#{config.root}/app/api)'
empty_directory 'app/api'
inside 'app/api' do
  copy_file 'api.rb'
end

empty_directory 'app/views/api'
inside 'app/views/api' do
  copy_file 'hello.jbuilder'
end

run 'bundle install'
generate 'minimum:omniauth:scaffold'
## delete root duplicate
run 'sed -i -e "/top#index/d" config/routes.rb'
remove_file 'app/controllers/top_controller.rb'
remove_file 'app/views/layouts/application.html.erb'
remove_file 'app/assets/stylesheets/scaffolds.css.scss'
remove_file 'app/views/top/index.html.erb'

rake 'db:create'
rake 'db:migrate'
rake 'bower:install'

uncomment_lines 'config/environments/development.rb', 'config.assets.debug = true'
comment_lines   'config/environments/development.rb', 'config.assets.debug = false'

git :init
git add: '.'
git commit: %Q{ -m 'first commit' }
