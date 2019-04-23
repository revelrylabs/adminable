defmodule Adminable.Router do
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
