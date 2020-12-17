every 1.day, at: '10:30 pm' do
    rake "cf:on_first_instance federal_register:find_sorns"
    rake "cf:on_first_instance all_sorns:update_all_mentioned_sorns"
  end
