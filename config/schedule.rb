every 1.day, at: '4:30 am' do
    rake "federal_register:find_sorns"
    rake "all_sorns:update_all_mentioned_sorns"
  end