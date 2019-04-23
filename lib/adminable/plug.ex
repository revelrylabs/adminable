defmodule Adminable.Plug do
  @moduledoc """
  Plug for admin routes. Add this to your phoenix router

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
  """

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn
    |> Plug.Conn.assign(:repo, Keyword.fetch!(opts, :repo))
    |> Plug.Conn.assign(:schemas, Keyword.get(opts, :schemas, %{}))
    |> Plug.Conn.assign(:layout, Keyword.get(opts, :layout, {Adminable.LayoutView, "app.html"}))
    |> Adminable.Router.call(opts)
  end
end
