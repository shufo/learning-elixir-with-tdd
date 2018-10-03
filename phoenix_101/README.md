# Phoenix101

Getting Started Phoenix with TDD.

## Usage

- Install dependencies

```bash
mix deps.get
cd assets && npm install && node node_modules/brunch/bin/brunch build
```

- Run MySQL in localhost (with docker)

```bash
$ docker run -itd -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=phoenix -p 3306:3306 mysql:5
```

- migration

```
mix ecto.create
mix ecto.migrate
```

- run up the server

```
mix phx.server
```

- Write the modules to pass the tests

```
$ mix test
```
