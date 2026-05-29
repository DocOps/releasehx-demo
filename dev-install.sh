#!/usr/bin/env bash
set -e

echo "Prebuilding local releasehx gem..."
( cd ../releasehx && bundle exec rake build:gem )

echo "Installing local releasehx gem..."
gem install $(ls -t ../releasehx/pkg/releasehx-*.gem | head -1)

echo "Running bundle install..."
bundle install