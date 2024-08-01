source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem 'rails', '~> 7.1.0'
gem 'good_job', '~> 4.1'
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
gem 'sass-rails'
gem 'sprockets-rails'
gem 'jsbundling-rails'
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

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 5.3'
  gem 'launchy'
end
