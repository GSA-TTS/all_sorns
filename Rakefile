# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :cf do
    desc "Only run on the first application instance"
    task :on_first_instance do
      instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
      exit(0) unless instance_index == 0
    end
  end
