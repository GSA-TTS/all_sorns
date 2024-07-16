# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.js" # @3.7.1
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @7.1.0
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @7.3.0
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @6.1.7
pin "list.js" # @2.3.1
pin "string-natural-compare" # @2.0.3
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
