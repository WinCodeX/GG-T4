#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# ./bin/rails assets:precompile
# ./bin/rails assets:clean

echo "=== Dropping and Creating Database ==="
bundle exec rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 || true
bundle exec rake db:create

echo "=== Running Migrations Step-by-Step ==="

bundle exec rake db:migrate:up VERSION=20250425192850  # agents
bundle exec rake db:migrate:up VERSION=20250425192851  # locations
bundle exec rake db:migrate:up VERSION=20250425192852  # areas
bundle exec rake db:migrate:up VERSION=20250425192853  # courier_services
bundle exec rake db:migrate:up VERSION=20250425192854  # packages

echo "=== Precompiling Assets ==="
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "=== Build Complete Successfully ==="