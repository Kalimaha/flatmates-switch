[![Build Status](https://travis-ci.org/Kalimaha/switch.svg?branch=master)](https://travis-ci.org/Kalimaha/switch)
[![Coverage Status](https://coveralls.io/repos/github/Kalimaha/switch/badge.svg?branch=master)](https://coveralls.io/github/Kalimaha/switch?branch=master)

# Switch
Feature toggles server.

## Up and Running
This project uses Docker and Docker compose for development. To build the images, run:

```
docker-compose build
```

The first time you will need to create the DB:

```
docker-compose run web mix db.create
docker-compose run web mix db.migrate
```

Then, to start the app:

```
docker-compose up web
```

You can now visit the homepage at http://localhost:4000.

## Tests
The first time you will need to create the DB:

```
docker-compose run test mix db.create
docker-compose run test mix db.migrate
```

To run tests, execute:

```
docker-compose run test mix test
```
