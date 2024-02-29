FROM ruby:latest

WORKDIR /app

COPY . .

RUN apt-get update -qq && \
    apt-get install -y postgresql-client && \
    gem install bundler && \
    bundle install

CMD ["ruby", "app.rb"]
