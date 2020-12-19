bundle exec rake cf:on_first_instance db:migrate
bundle exec whenever --update-crontab
bundle exec rails s -p $PORT -e production