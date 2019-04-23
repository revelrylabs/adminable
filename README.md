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

- Implement `Adminable` protocol for selected schemas you want to see in admin dashboard

```elixir
defimpl Adminable, for: MyApp.User do
  def source(_schema) do
    MyApp.User.__schema__(:source)
  end

  def readable_fields(_schema) do
    MyApp.User.__schema__(:fields)
  end

  def editable_fields(_schema) do
    MyApp.User.__schema__(:fields) -- MyApp.User.__schema__(:primary_key)
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
    repo: MyApp.Repo,
    schemas: %{"users" => MyApp.User},
    layout: {MyAppWeb.LayoutView, "app.html"}
  ])
end
```
