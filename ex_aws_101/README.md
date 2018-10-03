# ExAws101

Getting Started Elixir and AWS with TDD.

## Usage

- Install dependencies

```
$ mix deps.get
```

- Run [localstack](https://github.com/localstack/localstack) (using docker)

```bash
$ docker run -itd -p 4567-4582:4567-4582 -p 8080:8080 localstack/localstack
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
