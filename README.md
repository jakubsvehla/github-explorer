# GitHub Explorer

Explore the GitHub API like a boss!

## Installation

Github Explorer requires Ruby 1.9.2+, PostgreSQL and Redis.

You also need to [register your application][register] before getting started to get a client id and client secret.

    $ bundle install

    $ createdb github-explorer

    $ rake db:migrate
    $ rake db:seed

    $ export CLIENT_ID=YOUR_CLIENT_ID
    $ export CLIENT_SECRET=YOUR_CLIENT_SECRET

    $ bundle exec rackup

    $ open http://localhost:9292/

**Now you are ready to explore!**

## Demo app

[http://github-explorer.herokuapp.com][demo]

It's running on [Heroku][heroku] and using [Heroku Postgres][postgres] and [Redis To Go][redistogo].

[register]: 'https://github.com/settings/applications/new'
[demo]: 'http://github-explorer.herokuapp.com'
[heroku]: 'http://www.heroku.com'
[postgres]: 'https://postgres.heroku.com/'
[redistogo]: 'http://redistogo.com/'