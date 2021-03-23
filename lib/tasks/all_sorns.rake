namespace :federal_register do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    FindSornsJob.perform_later
  end
end

namespace :cf do
  desc "Only run on the first application instance"
  task :on_first_instance do
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    exit(0) unless instance_index == 0
  end
end