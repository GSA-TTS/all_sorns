# 10x - Privacy Dashboard - Phase 4

[![Known Vulnerabilities](https://snyk.io/test/github/18F/all_sorns/badge.svg)](https://snyk.io/test/github/18F/all_sorns)
[![Maintainability](https://api.codeclimate.com/v1/badges/c24db1125b3c714fbf9d/maintainability)](https://codeclimate.com/github/18F/all_sorns/maintainability)

## Introduction

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

## Developer Setup

### Running Locally

#### 1. Setup Environment

SORN DASH has a simple technical stack - you need a computer with:

* Ruby on Rails 6
* Postgresql 12 or later
* **Recommended:** Ruby version manager (RVM, chruby, or similar)

Make sure that **postgresql** is installed and running:

```bash
brew install postgresql
brew services start postgresql
```

Use a ruby version manager to set the local SORN DASH directory to the
ruby version found in the **.ruby-version** file. Finally -- ensure that
you have Ruby’s
[bundler](https://bundler.io/) and
[yarn](https://rubygems.org/gems/yarn/versions/0.1.1)
installed and install the necessary project dependencies.

```bash
gem install bundler
gem install yarn
```

Install the necessary project dependencies using:

```bash
bundle install
yarn install --check-files
```

### 2. Create and populate local database

Now that you have the environment set-up, create the database:

`bundle exec rails db:setup`

Once this is complete, run the following command to fetch all the SORNs
from the Federal Register API and populate your local database (this
takes about an hour and a half the first time it is run, to download and
populate the database):

`bundle exec rails federal_register:find_sorns`

After the database has been populated, run these commands to update the
links between SORNs that is displayed in the search results:

```bash
bundle exec rails all_sorns:update_all_mentioned_sorns
bundle exec rails all_sorns:refresh_search
```

You can now run SORN DASH locally using:

```bash
export RAILS_ENV=development
bundle exec rails server -e $RAILS_ENV
```

SORN DASH is now running locally on your computer!

Open a browser and go to
[https://localhost:3000/](https://localhost:3000/)

Note: that in Chrome you may have to go into incognito in order to get around the SSL requirements.

## Keeping local version up to date

Certain changes in the code will require you to run updates before being
able to run SORN DASH locally again.

Changes to the schema will require a database migration before SORN DASH
can be run. Run this with:

**>** bundle exec rails db:migrate

Adding or updating the included gems will require you to update your
ruby packages. Run this with:

**>** bundle install

* [How search works](/docs/search.md)
* [About the data](/docs/data.md)
* [Devops setup](/docs/devops.md)
* [Product roadmap](/docs/product.md)
* [Research and design](/docs/research-and-design.md)
* [Compliance](/docs/compliance.md)

### Who

- [ondrae](https://github.com/ondrae)
- [peterrowland](https://github.com/peterrowland)
- [igorkorenfeld](https://github.com/igorkorenfeld)
- [lauraGgit](https://github.com/lauraGgit)

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
