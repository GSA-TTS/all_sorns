# 10x - Privacy Dashboard - Phase 4

[![Known Vulnerabilities](https://snyk.io/test/github/18F/all_sorns/badge.svg)](https://snyk.io/test/github/18F/all_sorns)
[![Maintainability](https://api.codeclimate.com/v1/badges/c24db1125b3c714fbf9d/maintainability)](https://codeclimate.com/github/18F/all_sorns/maintainability)
## All of the SORNs 🎵

# Introduction

We are building a website that saves privacy offices time by speeding up
search and adding structure to System of Records Notices (SORNs) and
helps the public understand what data the government collects about
them.

SORN DASH is a public dashboard for finding information about the
privacy impacts and protections of government IT systems. It is a
ruby-on-rails application that processes System of Records Notices
(SORNs) published in the [<span class="underline">Federal
Register</span>](https://www.federalregister.gov/) and stores them as
structured records in a database. It enables search and exploration of
these important privacy documents that inform the public about the
existence and current state of government IT systems that collect and
store personally-identifiable information (PII).

SORN DASH was created by
[<span class="underline">18F</span>](https://18f.gsa.gov/) in
collaboration with the [<span class="underline">Federal Privacy
Council</span>](https://www.fpc.gov/) with funding from
[<span class="underline">10x</span>](https://10x.gsa.gov/).

SORN DASH is hosted and maintained by the TTS Identity Program
Management Office.

### How search works
We use postgres' built in [full text search](https://www.postgresql.org/docs/current/textsearch.html) ability. We do it by combining two approaches though, so we wanted to detail it here to explain the difference.

The default search searches against all of our SORN data at once. It uses a [materialized view](https://www.postgresql.org/docs/13/rules-materializedviews.html) to combine all of our data into one single column that is optimized for full text search. This view needs to be refreshed whenever the data changes, which is once a day in our case.

If a user decides to search only a subset of columns, using the Section filters checkboxes, then we use a different approach. We've created [generated columns](https://www.postgresql.org/docs/13/ddl-generated-columns.html) for each of our existing data columns, each optimized for full text search. We then search against that subset of columns. These columns are always up to date. It's a little slower than the materialized view, but allows per column search to still be fast. This column type is new, just introduced in PostgreSQL 12.

The materialized view is created and versioned by the great [Scenic gem](https://github.com/scenic-views/scenic). The view is searched against by the FullSornSearch model.

Both approaches for full text search use the incredible [pg_search gem](https://github.com/Casecommons/pg_search).

These two articles explaining these approaches were very helpful:
- [Optimizing full-text search with Postgres materialized view in Rails](https://caspg.com/blog/optimizing-full-text-search-with-postgres-materialized-view-in-rails)
- [Full Text Search in Milliseconds with Rails and PostgreSQL](https://pganalyze.com/blog/full-text-search-ruby-rails-postgres)


# Developer Setup

## Running Locally

### 1\. Setup Environment

SORN DASH has a simple technical stack - you need a computer with:

  - > Ruby on Rails v.2.7.1

  - > Postgresql 12 or later

  - > **Recommended:** Ruby version manager (RVM, chruby, or similar)

Make sure that **postgresql** is installed and running:

> **\>** brew install postgresql
> 
> **\>** brew services start postgresql

Use a ruby version manager to set the local SORN DASH directory to the
ruby version found in the **.ruby-version** file. Finally -- ensure that
you have Ruby’s
[<span class="underline">bundler</span>](https://bundler.io/) and
[<span class="underline">yarn</span>](https://rubygems.org/gems/yarn/versions/0.1.1)
installed and install the necessary project dependencies.

> **\>** gem install bundler
> 
> **\>** gem install yarn

Install the necessary project dependencies using:

> **\>** bundle install
> 
> **\>** yarn install --check-files

### 2\. Create and populate local database

Now that you have the environment set-up, create the database and
webserver using:

> **\>** bundle exec rails db:setup
> 
> **\>** bundle exec rails server

Once this is complete, run the following command to fetch all the SORNs
from the Federal Register API and populate your local database (this
takes about an hour and a half the first time it is run, to download and
populate the database):

> **\>** bundle exec rails federal\_register:find\_sorns

After the database has been populated, run these commands to update the
links between SORNs that is displayed in the search results:

**\>** bundle exec rails all\_sorns:update\_all\_mentioned\_sorns

**\>** Bundle exec rails all\_sorns:refresh\_search

You can now run SORN DASH locally using:

**\>** bundle exec rails s

SORN DASH is now running locally on your computer\!

Open a browser and go to
[<span class="underline">https://localhost:3000/</span>](https://localhost:3000/)

## Keeping local version up to date

Certain changes in the code will require you to run updates before being
able to run SORN DASH locally again.

Changes to the schema will require a database migration before SORN DASH
can be run. Run this with:

**\>** bundle exec rails db:migrate

Adding or updating the included gems will require you to update your
ruby packages. Run this with:

**\>** bundle install


### Who
- [ondrae](https://github.com/ondrae)
- [peterrowland](https://github.com/peterrowland)
- [igorkorenfeld](https://github.com/igorkorenfeld)
- [lauraGgit](https://github.com/lauraGgit)