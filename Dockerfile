FROM ruby:alpine

RUN apk --no-cache add git

ADD . /app

WORKDIR /app

RUN bin/setup

