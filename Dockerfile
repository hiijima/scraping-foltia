# Dockerfile
FROM ruby:2.4.0
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir /app

RUN gem install bundler

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
WORKDIR /app

CMD ruby /app/src/main.rb
