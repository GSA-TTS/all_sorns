bundle exec rake cf:on_first_instance db:migrate
if [ "$1" = "update" ] ; then
    bundle exec rails cf:on_first_instance federal_register:find_sorns
fi
bundle exec rails s -p $PORT -e production