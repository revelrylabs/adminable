defmodule Adminable.AdminController do
  @moduledoc false

  use Phoenix.Controller, namespace: Adminable
  import Plug.Conn
  alias Adminable.Router.Helpers, as: Routes

  defp schemas do
    Application.get_env(:adminable, :schemas, %{})
  end

  defp repo do
    Application.fetch_env!(:adminable, :repo)
  end

  defp layout do
    Application.get_env(:adminable, :layout, {Adminable.LayoutView, "app.html"})
  end

  def dashboard(conn, _params) do
    schemas = Map.keys(schemas())

    opts = [
      schemas: schemas
    ]

    conn
    |> put_layout(layout())
    |> render("dashboard.html", opts)
  end

  def index(conn, %{"schema" => schema} = params) do
    schema_module = schemas()[schema]

    page = repo().paginate(schema_module, params)

    schemas = repo().all(schema_module)

    opts = [
      schema_module: schema_module,
      schema: schema,
      schemas: schemas,
      schemas: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    ]

    conn
    |> put_layout(layout())
    |> render("index.html", opts)
  end

  def new(conn, %{"schema" => schema}) do
    schema_module = schemas()[schema]

    model = struct(schema_module)

    opts = [
      changeset: Adminable.create_changeset(model, %{}),
      schema_module: schema_module,
      schema: schema
    ]

    conn
    |> put_layout(layout())
    |> render("new.html", opts)
  end

  def create(conn, %{"schema" => schema, "data" => data}) do
    schema_module = schemas()[schema]

    new_schema = struct(schema_module)

    changeset = Adminable.create_changeset(new_schema, data)

    case repo().insert(changeset) do
      {:ok, _created} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} created!")
        |> redirect(to: Routes.admin_path(conn, :index, schema))

      {:error, changeset} ->
        opts = [
          changeset: changeset,
          schema_module: schema_module,
          schema: schema
        ]

        conn
        |> put_flash(:error, "#{String.capitalize(schema)} failed to create!")
        |> put_status(:unprocessable_entity)
        |> put_layout(layout())
        |> render("new.html", opts)
    end
  end

  def edit(conn, %{"schema" => schema, "pk" => pk}) do
    schema_module = schemas()[schema]

    model =
      schema_module.__schema__(:associations)
      |> Enum.reduce(repo().get(schema_module, pk), fn a, m ->
        repo().preload(m, a)
      end)

    opts = [
      changeset: Adminable.edit_changeset(model, %{}),
      schema_module: schema_module,
      schema: schema,
      pk: pk
    ]

    conn
    |> put_layout(layout())
    |> render("edit.html", opts)
  end

  def update(conn, %{"schema" => schema, "pk" => pk, "data" => data}) do
    schema_module = schemas()[schema]

    item = repo().get!(schema_module, pk)

    changeset = Adminable.edit_changeset(item, data)

    case repo().update(changeset) do
      {:ok, _updated_model} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} ID #{pk} updated!")
        |> redirect(to: Routes.admin_path(conn, :index, schema))

      {:error, changeset} ->
        opts = [
          changeset: changeset,
          schema_module: schema_module,
          schema: schema,
          pk: pk
        ]

        conn
        |> put_flash(:error, "#{String.capitalize(schema)} ID #{pk} failed to update!")
        |> put_status(:unprocessable_entity)
        |> put_layout(layout())
        |> render("edit.html", opts)
    end
  end
end
