source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
gem 'good_job', '>= 1.9.4'
gem 'pg'
gem 'httparty'
gem 'federal_register', '~> 0.7.6'
gem 'saxerator'
gem 'pg_search'
gem 'kaminari', '>= 1.2.1'
gem 'scenic', '>= 1.5.4'

# Use Puma as the app server
gem 'puma', '~> 5.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0.2'

  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'factory_bot_rails', '>= 6.2.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.35.3'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '>= 4.6.0'
  gem 'launchy'
end
