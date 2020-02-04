defmodule Adminable.MixProject do
  use Mix.Project

  def project do
    [
      app: :adminable,
      version: "0.3.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "Adminable",
      source_url: "https://github.com/revelrylabs/adminable",
      homepage_url: "https://github.com/revelrylabs/adminable",
      # The main page in the docs
      docs: [main: "Adminable", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.11"},
      {:ecto, "~> 3.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:harmonium, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description do
    """
    Create admin interfaces for Ecto schemas in Phoenix apps
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Revelry Labs"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/revelrylabs/adminable"
      },
      build_tools: ["mix"]
    ]
  end
end
