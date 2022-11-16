#!/bin/bash

cd "$(dirname -- "$0";)"

# Install rake and bundler
gem install rake bundler

# Build logstash
pushd /logstash
./gradlew installDevelopmentGems
bundle config set --local path vendor/bundle
bundle install
rake bootstrap

# Configure logstash-integration-jdbc
popd
./gradlew vendor
bundle install
