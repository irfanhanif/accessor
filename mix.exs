defmodule Accessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :accessor,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package(),
      docs: [
        main: "Accessor"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21.2"},
      {:excoveralls, "~> 0.11.2", only: :test}
    ]
  end

  defp package do
    %{
      description: "Accessor is an Elixir data structure manipulator wrapper",
      licenses: ["MIT"],
      maintainers: ["Irfan Hanif"],
      links: %{"GitHub" => "https://github.com/irfanhanif/accessor.git"},
    }
  end
end
