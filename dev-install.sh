#!/usr/bin/env bash
set -e

echo "Prebuilding local releasehx gem..."
( cd ../releasehx && rake prebundle )

echo "Running bundle install..."
bundle install