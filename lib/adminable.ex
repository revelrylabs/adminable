defmodule Adminable do
  @moduledoc """
  Behaviour to capture how to build admin interfaces and which fields to allow to edit

  ## Configuration

  - Add `use Adminable` to your Ecto Schema. Optionally

  ```elixir
  defmodule MyApp.User do
    use Ecto.Schema
    import Ecto.{Query, Changeset}, warn: false
    use Adminable

    ...
  end
  ```

  - optionally implement `fields/0`, `create_changeset/2` and `edit_changeset/2`

  - Forward to `Adminable.Router`

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
  """

  @doc """
  A list of fields for to show and edit in Adminable. The primary key will be excluded from
  create and edit forms
  """
  @callback fields() :: [atom()]

  @doc """
  Returns a changeset used for creating new schemas
  """
  @callback create_changeset(any(), any()) :: Ecto.Changeset.t()

  @doc """
  Returns a changeset used for editing existing schemas
  """
  @callback edit_changeset(any(), any()) :: Ecto.Changeset.t()

  defmacro __using__(_) do
    quote do
      @behaviour Adminable

      def fields() do
        __MODULE__.__schema__(:fields)
      end

      def create_changeset(schema, data) do
        __MODULE__.changeset(schema, data)
      end

      def edit_changeset(schema, data) do
        __MODULE__.changeset(schema, data)
      end

      defoverridable fields: 0, create_changeset: 2, edit_changeset: 2
    end
  end
end
