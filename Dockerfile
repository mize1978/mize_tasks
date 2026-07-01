FROM ruby:3.1.4

RUN apt-get update -qq && apt-get install -y nodejs libpq-dev yarn

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

ENV RAILS_ENV=production
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]