# ExRedis101

Getting Started Elixir and Redis with TDD.

## Usage

- Get dependencies

```bash
$ mix deps.get
```

- Run redis (using docker)

```bash
$ docker run -d -p 6379:6379 --name redis redis:alpine
```

- Write the modules to pass the tests

```
$ mix test
```

## Contribution

- Run formatter before commit to Git

```
$ mix format
```
