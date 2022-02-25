FROM ruby:3.0.2

RUN apt-get update && apt -y install gnupg2 nodejs yarn cron lsb-release  && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && apt-get install -qq -y postgresql-client-14 && rm -rf /var/lib/apt/lists/*

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler:2.1.4
RUN bundle install

COPY . /myapp

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]