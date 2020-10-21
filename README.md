# 10x - Privacy Dashboard - Phase 4
## All of the SORNs 🎵

### What
Prototype - [https://allsorns-exhausted-quoll-ku.app.cloud.gov/](https://allsorns-exhausted-quoll-ku.app.cloud.gov/)

This repository is for prototyping a service to make all of the federal government's [System Of Record Notices](https://www.gsa.gov/reference/gsa-privacy-program/systems-of-records-privacy-act) more usable for government privacy officer's and the public.

### Why
!Put the slide deck here!

To read more about how we got here, see our [Phase 3 work](https://github.com/18F/privacy-tools/blob/master/README.md) and our [Privacy Dashboard built for GSA](https://cg-9341b8ea-025c-4fe2-aa6c-850edbebc499.app.cloud.gov/site/18f/privacy-dashboard/).

### How
This is a Rails app, running on Cloud.gov. It gets SORNs from the Federal Register. It reads those SORNs and separates every section into their own database column.


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
