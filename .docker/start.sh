#!/bin/sh

export RAILS_ENV=${RAILS_ENV:-development}
echo "Running with RAILS_ENV ${RAILS_ENV}..."

bundle exec rake db:migrate

echo "If you're running this for the first time, you probably want to load the database with some data."
echo "To do that, run "
echo "  docker compose exec web bundle exec rails federal_register:find_sorns"
echo ""

bundle exec rails server -e $RAILS_ENV -p 3000 -b 0.0.0.0

