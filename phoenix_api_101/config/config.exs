# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_api_101,
  ecto_repos: [PhoenixApi101.Repo]

# Configures the endpoint
config :phoenix_api_101, PhoenixApi101Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/y/JBKgoCCGz1MRSUectWo+39VhtaNE04bY3fGWEK1AVmg0009pCDKYsccdzI1sm",
  render_errors: [view: PhoenixApi101Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixApi101.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"],
  "application/json" => ["json"]
}

config :phoenix_api_101, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: ApiTestWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: ApiTestWeb.Endpoint
    ]
  }

config :phoenix_api_101, PhoenixApi101.ElasticsearchCluster,
  # The URL where Elasticsearch is hosted on your system
  url: "http://localhost:9200",

  # If your Elasticsearch cluster uses HTTP basic authentication,
  # specify the username and password here:
  username: "root",
  password: "root",

  # If you want to mock the responses of the Elasticsearch JSON API
  # for testing or other purposes, you can inject a different module
  # here. It must implement the Elasticsearch.API behaviour.
  api: Elasticsearch.API.HTTP,

  # Customize the library used for JSON encoding/decoding.
  # or Jason
  json_library: Poison,

  # You should configure each index which you maintain in Elasticsearch here.
  # This configuration will be read by the `mix elasticsearch.build` task,
  # described below.
  indexes: %{
    # This is the base name of the Elasticsearch index. Each index will be
    # built with a timestamp included in the name, like "posts-5902341238".
    # It will then be aliased to "posts" for easy querying.
    posts: %{
      # This file describes the mappings and settings for your index. It will
      # be posted as-is to Elasticsearch when you create your index, and
      # therefore allows all the settings you could post directly.
      settings: "priv/elasticsearch/users.json",

      # This store module must implement the Elasticsearch.Store
      # behaviour. It will be used to fetch data for each source in each
      # indexes' `sources` list, below:
      store: PhoenixApi101.ElasticsearchStore,

      # This is the list of data sources that should be used to populate this
      # index. The `:store` module above will be passed each one of these
      # sources for fetching.
      #
      # Each piece of data that is returned by the store must implement the
      # Elasticsearch.Document protocol.
      sources: [PhoenixApi101.Accounts.User],

      # When indexing data using the `mix elasticsearch.build` task,
      # control the data ingestion rate by raising or lowering the number
      # of items to send in each bulk request.
      bulk_page_size: 5000,

      # Likewise, wait a given period between posting pages to give
      # Elasticsearch time to catch up.
      # 15 seconds
      bulk_wait_interval: 15_000
    },
    users: %{
      settings: "priv/elasticsearch/users.json",

      # This store module must implement the Elasticsearch.Store
      # behaviour. It will be used to fetch data for each source in each
      # indexes' `sources` list, below:
      store: PhoenixApi101.ElasticsearchStore,

      # This is the list of data sources that should be used to populate this
      # index. The `:store` module above will be passed each one of these
      # sources for fetching.
      #
      # Each piece of data that is returned by the store must implement the
      # Elasticsearch.Document protocol.
      sources: [PhoenixApi101.Accounts.User],

      # When indexing data using the `mix elasticsearch.build` task,
      # control the data ingestion rate by raising or lowering the number
      # of items to send in each bulk request.
      bulk_page_size: 5000,

      # Likewise, wait a given period between posting pages to give
      # Elasticsearch time to catch up.
      # 15 seconds
      bulk_wait_interval: 15_000
    }
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
