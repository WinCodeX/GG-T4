#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# ./bin/rails assets:precompile
# ./bin/rails assets:clean

# echo "=== Dropping and Creating Database ==="
# bundle exec rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 || true
# bundle exec rails db:create

echo "=== Running Migrations Step-by-Step ==="

bundle exec rails db:migrate:up VERSION=20250425200130   # locations
bundle exec rails db:migrate:up VERSION=20250425194436  #areas
bundle exec rails db:migrate:up VERSION=20250425192850  # agents
bundle exec rails db:migrate:up VERSION=20250425201824   # courier_services
bundle exec rails db:migrate:up VERSION=20250425192853   # packages


bundle exec rails db:migrate:up VERSION=20250504190703

echo "=== Seeding Test Data ==="
bundle exec rails db:seed

bin/rails db:migrate

echo "=== Precompiling Assets ==="
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "=== Build Complete Successfully ==="

#  bundle install; bundle exec rails assets:precompile; bundle exec rails assets:clean;