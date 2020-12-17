every 1.day, at: '10:30 pm' do
  rake "cf:on_first_instance federal_register:find_sorns"
end
