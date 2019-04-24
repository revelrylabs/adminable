# Adminable

Create admin interfaces through defining the `Adminable` protocol and using [reflection](https://hexdocs.pm/ecto/Ecto.Schema.html#module-reflection)

Based on blog post [here](https://lytedev.io/blog/ecto-reflection-for-simple-admin-crud-forms/)

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

- Implement `Adminable` protocol for selected schemas you want to see in admin dashboard

```elixir
defimpl Adminable, for: MyApp.User do
  def fields(schema) do
    MyApp.User.__schema__(:fields)
  end

  def create_changeset(s, data) do
    MyApp.User.changeset(s, data)
  end

  def edit_changeset(s, data) do
    MyApp.User.edit_changeset(s, data)
  end
end
```

- Forward to `Adminable.Router`

```elixir
scope "/admin" do
  pipe_through [:browser, :my, :other, :pipelines]

  forward("/", Adminable.Plug, [
    otp_app: :my_app,
    repo: MyApp.Repo,
    layout: {MyAppWeb.LayoutView, "app.html"}
  ])
end
```
