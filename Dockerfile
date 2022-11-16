FROM docker/dev-environments-default:stable-1

RUN apt update
RUN apt upgrade -y

# Install JDK 11
RUN apt install openjdk-11-jdk -y

# Get logstash source code
RUN git clone https://github.com/elastic/logstash.git /logstash

WORKDIR /logstash

# Install rvm Ruby Version Manager
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=$(cat .ruby-version)

SHELL ["/bin/bash", "-c"]

# Install rake and bundler
RUN source /etc/profile.d/rvm.sh && gem install rake bundler

ENV OSS=true
ENV LOGSTASH_PATH=/logstash
ENV LOGSTASH_SOURCE=1

# Build logstash
RUN ./gradlew installDevelopmentGems

RUN source /etc/profile.d/rvm.sh && bundle config set --local path vendor/bundle
RUN source /etc/profile.d/rvm.sh && bundle install

RUN source /etc/profile.d/rvm.sh && rake bootstrap

# Configure logstash-integration-jdbc
COPY / /logstash-integration-jdbc

WORKDIR /logstash-integration-jdbc

RUN ./gradlew vendor
RUN source /etc/profile.d/rvm.sh && bundle install
