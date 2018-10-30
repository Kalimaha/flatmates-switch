# Base image
FROM elixir:1.7.3-alpine

# Install PostgreSQL client
RUN apk update && apk add -y postgresql-client git

# Add source code to the image
ADD . /app

# Install Phoenix
RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
RUN mix local.rebar --force

# Set work directory
WORKDIR /app

# Install dependencies
RUN mix deps.get

# Expose Phoenix's default port
EXPOSE 4000
