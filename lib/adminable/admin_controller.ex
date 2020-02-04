defmodule Adminable.AdminController do
  @moduledoc false

  use Phoenix.Controller, namespace: Adminable
  import Plug.Conn

  def dashboard(conn, _params) do
    schemas = Map.keys(conn.assigns.schemas)

    opts = [
      schemas: schemas
    ]

    conn
    |> put_layout(conn.assigns.layout)
    |> render("dashboard.html", opts)
  end

  def index(conn, %{"schema" => schema} = params) do
    schema_module = conn.assigns.schemas[schema]

    paginate_config = [
      page_size: 20,
      page: Map.get(params, "page", 1),
      module: conn.assigns.repo
    ]

    page = Scrivener.paginate(schema_module, paginate_config)

    opts = [
      schema_module: schema_module,
      schema: schema,
      schemas: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    ]

    conn
    |> put_layout(conn.assigns.layout)
    |> render("index.html", opts)
  end

  def new(conn, %{"schema" => schema}) do
    schema_module = conn.assigns.schemas[schema]

    model = struct(schema_module)

    opts = [
      changeset: schema_module.create_changeset(model, %{}),
      schema_module: schema_module,
      schema: schema
    ]

    conn
    |> put_layout(conn.assigns.layout)
    |> render("new.html", opts)
  end

  def create(conn, %{"schema" => schema, "data" => data}) do
    schema_module = conn.assigns.schemas[schema]

    new_schema = struct(schema_module)

    changeset = schema_module.create_changeset(new_schema, data)

    case conn.assigns.repo.insert(changeset) do
      {:ok, _created} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} created!")
        |> redirect(to: Adminable.Router.Helpers.admin_path(conn, :index, schema))

      {:error, changeset} ->
        opts = [
          changeset: changeset,
          schema_module: schema_module,
          schema: schema
        ]

        conn
        |> put_flash(:error, "#{String.capitalize(schema)} failed to create!")
        |> put_status(:unprocessable_entity)
        |> put_layout(conn.assigns.layout)
        |> render("new.html", opts)
    end
  end

  def edit(conn, %{"schema" => schema, "pk" => pk}) do
    schema_module = conn.assigns.schemas[schema]

    model =
      schema_module.__schema__(:associations)
      |> Enum.reduce(conn.assigns.repo.get(schema_module, pk), fn a, m ->
        conn.assigns.repo.preload(m, a)
      end)

    opts = [
      changeset: schema_module.edit_changeset(model, %{}),
      schema_module: schema_module,
      schema: schema,
      pk: pk
    ]

    conn
    |> put_layout(conn.assigns.layout)
    |> render("edit.html", opts)
  end

  def update(conn, %{"schema" => schema, "pk" => pk, "data" => data}) do
    schema_module = conn.assigns.schemas[schema]

    item = conn.assigns.repo.get!(schema_module, pk)

    changeset = schema_module.edit_changeset(item, data)

    case conn.assigns.repo.update(changeset) do
      {:ok, _updated_model} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} ID #{pk} updated!")
        |> redirect(to: Adminable.Router.Helpers.admin_path(conn, :index, schema))

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
        |> put_layout(conn.assigns.layout)
        |> render("edit.html", opts)
    end
  end
end
