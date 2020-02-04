# Adminable

Create admin interfaces for Ecto Schemas in Phoenix apps

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

- Add `use Adminable` to your Ecto Schema

  ```elixir
  defmodule MyApp.User do
    use Ecto.Schema
    import Ecto.{Query, Changeset}, warn: false
    use Adminable

    ...
  end
  ```

- optionally implement fields/0, create_changeset/2 and edit_changeset/2

- Forward to `Adminable.Router`

```elixir
scope "/admin" do
  pipe_through [:browser, :my, :other, :pipelines]

  forward("/", Adminable.Plug, [
    otp_app: :my_app,
    repo: MyApp.Repo,
    schemas: [MyApp.User],
    layout: {MyAppWeb.LayoutView, "app.html"}
  ])
end
```

Arguments

- `otp_app` - Your app
- `repo` - Your app's Repo
- `schemas` - The schemas to make Admin sections for
- `view_module` - (Optional) The view_module to use to display pages. Uses Adminable's view module by default. You can export the view to modify using `mix adminable.gen.view MyWebModule`
- `layout` - (Optional) The layout to use
