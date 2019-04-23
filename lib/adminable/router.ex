defmodule Adminable.Router do
  @moduledoc """
  Router for admin routes. Add this to your phoenix router

  ```elixir
  scope "/admin" do
    pipe_through [:browser, :my, :other, :pipelines]

    forward("/", Adminable.Router)
  end
  ```
  """

  use Phoenix.Router

  scope "/", Adminable do
    get("/", AdminController, :dashboard)
    get("/:schema/", AdminController, :index)
    get("/:schema/new/", AdminController, :new)
    post("/:schema/new/", AdminController, :create)
    get("/:schema/edit/:pk", AdminController, :edit)
    put("/:schema/edit/:pk", AdminController, :update)
  end
end
