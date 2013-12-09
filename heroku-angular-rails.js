gem_group :development, :test do
  gem "rspec-rails"
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

gem_group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem "faraday"
gem "puma"
gem "haml-rails"
gem 'mysql2'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem "quiet_assets"
gem 'grape'
gem 'jpmobile', github: 'jpmobile/jpmobile'
gem 'kaminari'
gem 'ngmin-rails'
gem "rails_config"
gem "tapp"
gem "whenever"
gem 'annotate'

run "echo '.DS_Store' >> .gitignore"
run "echo 'config/settings.local.yml' >> .gitignore"
run "echo 'config/settings/*.local.yml' >> .gitignore"
run "echo 'config/environments/*.local.yml' >> .gitignore"
run "echo 'config/database.local.yml' >> .gitignore"

run "rm -rf test/"

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
