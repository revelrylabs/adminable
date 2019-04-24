defprotocol Adminable do
  @moduledoc """
  Protocol for to capture how to build admin interfaces and which fields to allow to edit

  ## Configuration

  - Implement `Adminable` protocol for selected schemas you want to see in admin dashboard

  ```elixir
  defimpl Adminable, for: MyApp.User do
    def fields(schema) do
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
      otp_app: :my_app,
      repo: MyApp.Repo,
      layout: {MyAppWeb.LayoutView, "app.html"}
    ])
  end
  ```
  """
  @fallback_to_any true

  @doc """
  A list of fields for to show and edit in Adminable. The primary key will be excluded from
  create and edit forms
  """
  @spec fields(any()) :: [atom()]
  def fields(schema)

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
  def fields(schema) do
    schema.__struct__.__schema__(:fields)
  end

  def create_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, fields(schema))
  end

  def edit_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, fields(schema))
  end
end
