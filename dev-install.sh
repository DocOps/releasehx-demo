#!/usr/bin/env bash
set -e

echo "Prebuilding local releasehx gem..."
( cd ../releasehx && bundle exec rake build:gem )

echo "Running bundle install..."
bundle install