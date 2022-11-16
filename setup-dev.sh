#!/bin/bash

cd "$(dirname -- "$0";)"

# Install rake and bundler
gem install rake bundler

export OSS=true
export LOGSTASH_PATH=/logstash
export LOGSTASH_SOURCE=1

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
