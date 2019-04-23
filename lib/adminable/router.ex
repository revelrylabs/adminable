defmodule Adminable.Router do
  use Phoenix.Router

  scope "/", Adminable do
    get("/", AdminController, :dashboard)
    get("/:schema/", AdminController, :index)
    get("/new/:schema", AdminController, :new)
    post("/new/:schema", AdminController, :create)
    get("/edit/:schema/:pk", AdminController, :edit)
    put("/update/:schema/:pk", AdminController, :update)
  end
end
