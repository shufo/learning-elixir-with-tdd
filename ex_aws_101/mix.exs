defmodule ExAws101.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_aws_101,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0"},
      {:ex_aws_kinesis, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws_dynamo, "~> 2.0"},
      {:ex_aws_dynamo_streams, "~> 2.0"},
      {:ex_aws_firehose, "~> 2.0"},
      {:ex_aws_lambda, "~> 2.0"},
      {:ex_aws_sns, "~> 2.0"},
      {:ex_aws_sqs, "~> 2.0"},
      {:ex_aws_ses, "~> 2.0"},
      {:ex_aws_route53, "~> 2.0"},
      {:ex_aws_cloudwatch, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:poison, "~> 3.0"},
      {:httpoison, ">= 0.0.0"}
    ]
  end
end
