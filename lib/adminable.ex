defprotocol Adminable do
  @moduledoc """
  Protocol for to capture how to build admin interfaces and which fields to allow to edit

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

    def index_fields(_schema) do
      MyApp.User.__schema__(:fields)
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
  """
  @fallback_to_any true

  @doc """
  The source of the schema. Usually the table's name
  """
  @spec source(any()) :: binary()
  def source(schema)

  @doc """
  A list of visible fields on the schema's index page
  """
  @spec readable_fields(any()) :: [atom()]
  def readable_fields(schema)

  @doc """
  A list of editable fields on the schema's new and edit pages
  """
  @spec editable_fields(any()) :: [atom()]
  def editable_fields(schema)

  @doc """
  Returns a changeset used for creating new schemas
  """
  @spec create_changeset(any(), any()) :: Ecto.Changeset.t()
  def create_changeset(schema, data)

  @doc """
  Returns a changeset used for editing existing schemas
  """
  @spec edit_changeset(any(), any()) :: Ecto.Changeset.t()
  def edit_changeset(schema, data)
end

defimpl Adminable, for: Any do
  def source(schema) do
    schema.__struct__.__schema__(:source)
  end

  def readable_fields(schema) do
    schema.__struct__.__schema__(:fields)
  end

  def editable_fields(schema) do
    schema.__struct__.__schema__(:fields) -- schema.__struct__.__schema__(:primary_key)
  end

  def create_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, editable_fields(schema))
  end

  def edit_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, editable_fields(schema))
  end
end
