FROM ruby:latest

WORKDIR /app

COPY . .

RUN apt-get update -qq && \
    apt-get install -y postgresql-client

RUN apt-get install -y chromium

RUN gem install bundler && \
    bundle install

CMD ["ruby", "app.rb"]
