defmodule Adminable.Plug do
  @moduledoc """
  Plug for admin routes. Add this to your phoenix router

  ```elixir
  scope "/admin" do
    pipe_through [:browser, :my, :other, :pipelines]

    forward("/", Adminable.Plug, [
      otp_app: :my_app,
      repo: MyApp.Repo,
      schemas: [MyApp.User],
      view_module: MyAppWeb.Adminable.AdminView
      layout: {MyAppWeb.LayoutView, "app.html"}
    ])
  end
  ```

  Arguments

  * `otp_app` - Your app
  * `repo` - Your app's Repo
  * `schemas` - The schemas to make Admin sections for
  * `view_module` - (Optional) The view_module to use to display pages. Uses Adminable's view module by default. You can export the view to modify using `mix adminable.gen.view MyWebModule`
  * `layout` - (Optional) The layout to use

  """

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    repo = Keyword.fetch!(opts, :repo)
    otp_app = Keyword.fetch!(opts, :otp_app)
    schemas = Keyword.get(opts, :schemas, [])
    view_module = Keyword.get(opts, :view_module, Adminable.AdminView)
    layout = Keyword.get(opts, :layout, {Adminable.LayoutView, "app.html"})

    schemas =
      Enum.map(schemas, fn schema ->
        {
          schema.__schema__(:source),
          schema
        }
      end)
      |> Enum.into(%{})

    conn
    |> Plug.Conn.put_private(:adminable_otp_app, otp_app)
    |> Plug.Conn.put_private(:adminable_repo, repo)
    |> Plug.Conn.put_private(:adminable_schemas, schemas)
    |> Plug.Conn.put_private(:adminable_layout, layout)
    |> Plug.Conn.put_private(:adminable_view_module, view_module)
    |> Adminable.Router.call(opts)
  end
end
