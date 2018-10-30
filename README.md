# Switch
Feature toggles server.

## Development
This project uses Docker and Docker compose for development. To build the images, run:

```
docker-compose build
```

The first time you will need to create the DB:

```
docker-compose run web mix ecto.create
docker-compose run web mix ecto.migrate
```

Then, to start the app:

```
docker-compose up web
```

You can now visit the homepage at http://localhost:4000.

## Tests
To run tests, execute:

```
docker-compose run test mix test
```
