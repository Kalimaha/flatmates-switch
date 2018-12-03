[![Build status](https://badge.buildkite.com/9b42047cbaa0218d9dc06b7234103e36e99be7b91c9b7d9f51.svg)](https://buildkite.com/rea/flatmates-switch)

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
