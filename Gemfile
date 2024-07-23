source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem 'rails', '~> 7.0.0'
gem 'good_job', '~> 4.0'
gem 'pg'
gem 'httparty'
gem 'federal_register', '~> 0.7'
gem 'rexml'
gem 'saxerator'
gem 'pg_search'
gem 'kaminari', '~> 1.2'
gem 'scenic', '~> 1.8'
gem 'base64'
gem 'bigdecimal'
gem 'mutex_m'
gem 'csv'

# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4', '>= 5.4.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.12'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 6.1'

  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'factory_bot_rails', '~> 6.4'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.2.1'
  gem 'listen', '~> 3.9'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 5.3'
  gem 'launchy'
end
