# 10x - Privacy Dashboard - Phase 4

[![Known Vulnerabilities](https://snyk.io/test/github/18F/all_sorns/badge.svg)](https://snyk.io/test/github/18F/all_sorns)
[![Maintainability](https://api.codeclimate.com/v1/badges/c24db1125b3c714fbf9d/maintainability)](https://codeclimate.com/github/18F/all_sorns/maintainability)
## All of the SORNs 🎵

### What
[Prototype](https://all-sorns.app.cloud.gov)

This repository is for prototyping a service to make all of the federal government's [System Of Record Notices](https://www.gsa.gov/reference/gsa-privacy-program/systems-of-records-privacy-act) more usable for government privacy officer's and the public.

### Why
We are building a dashboard for searching and exploring Privacy Act System of Records Notices (SORNs). This service will give privacy offices and their staff a better way to find SORNs using targeted search, and provides the public with an interface to explore and understand government privacy practices.

To read more about how we got here, see our [Phase 3 work](https://github.com/18F/privacy-tools/blob/master/README.md) and our [Privacy Dashboard built for GSA](https://cg-9341b8ea-025c-4fe2-aa6c-850edbebc499.app.cloud.gov/site/18f/privacy-dashboard/).

### How
This is a Rails app, running on Cloud.gov. It gets SORNs from the Federal Register every night. It reads those SORNs and separates every section into their own database column. Users can search against everything, or limit their search by SORN section, agencies, and publiction date.

### How search works
We use postgres' built in [full text search](https://www.postgresql.org/docs/current/textsearch.html) ability. We do it by combining two approaches though, so we wanted to detail it here to explain the difference.

The default search searches against all of our SORN data at once. It uses a [materialized view](https://www.postgresql.org/docs/13/rules-materializedviews.html) to combine all of our data into one single column that is optimized for full text search. This view needs to be refreshed whenever the data changes, which is once a day in our case.

If a user decides to search only a subset of columns, using the Section filters checkboxes, then we use a different approach. We've created [generated columns](https://www.postgresql.org/docs/13/ddl-generated-columns.html) for each of our existing data columns, each optimized for full text search. We then search against that subset of columns. These columns are always up to date. It's a little slower than the materialized view, but allows per column search to still be fast. This column type is new, just introduced in PostgreSQL 12.

The materialized view is created and versioned by the great [Scenic gem](https://github.com/scenic-views/scenic). The view is searched against by the FullSornSearch model.

Both approaches for full text search use the incredible [pg_search gem](https://github.com/Casecommons/pg_search).

These two articles explaining these approaches were very helpful:
- [Optimizing full-text search with Postgres materialized view in Rails](https://caspg.com/blog/optimizing-full-text-search-with-postgres-materialized-view-in-rails)
- [Full Text Search in Milliseconds with Rails and PostgreSQL](https://pganalyze.com/blog/full-text-search-ruby-rails-postgres)


## Local installation

Ensure that you have postgres running
```
brew install postgresql
brew services start postgresql
```

Use your ruby version manager to switch to the ruby version found in .ruby-version.

Then install the dependencies (and check for bundler)
```
if ! type "$bundler" > /dev/null; then
  gem install bundler
fi
bundle install
yarn install --check-files

bundle exec rails db:setup
bundle exec rails server
```

## Populate SORNS from the Federal register
Run
```
bundle exec rails federal_register:find_sorns
```


### Who
- [ondrae](https://github.com/ondrae)
- [peterrowland](https://github.com/peterrowland)
- [igorkorenfeld](https://github.com/igorkorenfeld)
- [lauraGgit](https://github.com/lauraGgit)