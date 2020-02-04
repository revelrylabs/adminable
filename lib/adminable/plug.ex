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
      layout: {MyAppWeb.LayoutView, "app.html"}
    ])
  end
  ```
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
    |> Plug.Conn.assign(:otp_app, otp_app)
    |> Plug.Conn.assign(:repo, repo)
    |> Plug.Conn.assign(:schemas, schemas)
    |> Plug.Conn.assign(:layout, layout)
    |> Plug.Conn.assign(:view_module, view_module)
    |> Adminable.Router.call(opts)
  end
end
