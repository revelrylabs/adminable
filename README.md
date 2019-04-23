# Adminable

MAKE IT LIKE ADMINIUM

Based on blog post [here](https://lytedev.io/blog/ecto-reflection-for-simple-admin-crud-forms/) and
[Django ModelAdmin object](https://docs.djangoproject.com/en/2.2/ref/contrib/admin/#modeladmin-objects)

Allows creating admin interfaces through defining the `Adminable` protocol and using [reflection](https://hexdocs.pm/ecto/Ecto.Schema.html#module-reflection)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `adminable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:adminable, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/adminable](https://hexdocs.pm/adminable).

## Configuration

```elixir
config :adminable,
  repo: MyApp.Repo,
  schemas: %{"users" => MyApp.User},
  layout: {MyAppWeb.LayoutView, "app.html"}
```

## Setup

```elixir
  scope "/admin" do
    pipe_through [:browser, :my, :other, :pipelines]

    forward("/", Adminable.Router)
  end
```
