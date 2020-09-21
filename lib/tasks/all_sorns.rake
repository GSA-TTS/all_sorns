namespace :all_sorns do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    FindSornsJob.perform_later
  end
end