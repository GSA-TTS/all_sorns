# Cribbed from https://github.com/lipanski/ruby-dockerfile-example/blob/master/plain_ruby_no_assets.Dockerfile

# Start from a small, trusted base image with the version pinned down
FROM ruby:2.7.1-alpine AS base

# Install system dependencies required both at runtime and build time
RUN apk add --update \
  postgresql-dev \
  tzdata \
  nodejs

# This stage will be responsible for installing gems
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg)
RUN apk add --update build-base
RUN apk add nodejs npm yarn

COPY Gemfile Gemfile.lock ./

# Install gems 
RUN bundle config set with "development test" && \
  bundle install --jobs=3 --retry=3

# Install NPM modules
COPY yarn.lock yarn.lock
RUN yarn install --check-files

# We're back at the base stage
FROM base

# Create a non-root user to run the app and own app-specific files
RUN adduser -D app

# Switch to this user
USER app

# We'll install the app in this directory
WORKDIR /home/app

# Copy over gems from the dependencies stage
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Copy over NPM modules from the dependencies stage
COPY --from=dependencies node_modules/ node_modules/

# Finally, copy over the code
# This is where the .dockerignore file comes into play
# Note that we have to use `--chown` here
COPY --chown=app . ./

# Launch the server (or run some other Ruby command)
# CMD ["bundle", "exec", "rackup"]
CMD [".docker/start.sh"]
