#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate