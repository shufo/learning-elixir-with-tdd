# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :ex_aws_101, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:ex_aws_101, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
#
config :ex_aws,
  access_key_id: "foo",
  secret_access_key: "bar"

config :ex_aws, :kinesis,
  scheme: "http://",
  host: "localhost",
  port: 4568,
  region: "us-east-1"

config :ex_aws, :dynamodb,
  scheme: "http://",
  host: "localhost",
  port: 4569,
  region: "us-east-1"

config :ex_aws, :dynamodb_streams,
  scheme: "http://",
  host: "localhost",
  port: 4570,
  region: "us-east-1"

config :ex_aws, :s3,
  scheme: "http://",
  host: "localhost",
  port: 4572,
  region: "us-east-1"

config :ex_aws, :firehose,
  scheme: "http://",
  host: "localhost",
  port: 4573,
  region: "us-east-1"

config :ex_aws, :lambda,
  scheme: "http://",
  host: "localhost",
  port: 4574,
  region: "us-east-1"

config :ex_aws, :sns,
  scheme: "http://",
  host: "localhost",
  port: 4575,
  region: "us-east-1"

config :ex_aws, :sqs,
  scheme: "http://",
  host: "localhost",
  port: 4576,
  region: "us-east-1"

config :ex_aws, :sqs,
  scheme: "http://",
  host: "localhost",
  port: 4576,
  region: "us-east-1"

config :ex_aws, :ses,
  scheme: "http://",
  host: "localhost",
  port: 4579,
  region: "us-east-1"

config :ex_aws, :route53,
  scheme: "http://",
  host: "localhost",
  port: 4580,
  region: "us-east-1"

config :ex_aws, :cloudwatch,
  scheme: "http://",
  host: "localhost",
  port: 4581,
  region: "us-east-1"
