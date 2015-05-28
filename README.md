# turi
Yet another trip planner.

[![Build Status](https://travis-ci.org/turi-inc/turi.svg?branch=develop)](https://travis-ci.org/turi-inc/turi)
[![Code Climate](https://codeclimate.com/github/turi-inc/turi/badges/gpa.svg)](https://codeclimate.com/github/turi-inc/turi)
[![Test Coverage](https://codeclimate.com/github/turi-inc/turi/badges/coverage.svg)](https://codeclimate.com/github/turi-inc/turi)
[![Security Status](https://hakiri.io/github/turi-inc/turi/develop.svg)](https://hakiri.io/github/turi-inc/turi/develop/shield)
[![Dependency Status](https://gemnasium.com/turi-inc/turi.svg)](https://gemnasium.com/turi-inc/turi)

## Installation guide

### Requirements

* Ruby 2.1.6

### Setup

Run the following commands:

```
bundle install
rake db:migrate
rake db:test:prepare
rake db:seed
```

### Running in production mode

If you want to use the production mode locally you have to do execute some additional steps:

#### Compile the assets

```
rake assets:precompile
```

#### Setup up PostgreSQL locally
Visit http://www.postgresql.org/ for more informations. Don't forget to update `config/databases.yml` accordings your local setup (don't commit these changes).

#### Dropbox Integration (obligatory)

Dropbox can not be tested without access to our Dropbox app and the related secrect keys. However you can create your own Dropbox app and set the keys `TURI_DROPBOX_KEY` and `TURI_DROPBOX_SECRET` accordingly.
After that you have to add `localhost:3000` to your Dropbox as allowed host. You should be able to test the Dropbox integration now locally.

## Testing

Turi is built automatically with travis (https://travis-ci.org/turi-inc/turi). To ensure that all tests are passing locally run:

```
rake spec
```

## Preview

You can have a look at the preview of the current master branch at the following url: http://turi.herokuapp.com/

## Documentup

Design is important. Therefore visit http://documentup.com/turi-inc/turi for a much more elegant README layout.
