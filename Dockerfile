FROM ruby:2.3

MAINTAINER Jonathan Reeve, v 0.1

RUN apt-get update

RUN apt-get install -y git default-libmysqlclient-dev mysql-server mysql-client

RUN mkdir /myapp
WORKDIR /myapp

RUN gem install bundler 

COPY ./Gemfile /myapp/Gemfile
COPY ./Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

# This should be after installing the bundle, so that any changes
# to the filesystem won't trigger a new bundle install command
COPY . /myapp

RUN mkdir /logs && touch /logs/development.log

# RUN rake db:setup
# RUN rake bootstrap:globals url={catalog url}

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]