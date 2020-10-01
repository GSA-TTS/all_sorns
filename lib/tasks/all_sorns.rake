namespace :federal_register do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    FindSornsJob.perform_later
  end
end

namespace :bulk do
  desc "Find new SORNs on the Federal Register API"
  task find_sorns: :environment do
    BulkSornParserJob.perform_later(url: 'https://www.govinfo.gov/bulkdata/PAI/2019/PAI-2019-DOD.xml')
    BulkSornParserJob.perform_later(url: 'https://www.govinfo.gov/bulkdata/PAI/2019/PAI-2019-JUSTICE.xml')
  end
end